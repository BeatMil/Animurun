extends CharacterBody2D


@export var default_pos: Node


# Beat's own state machine XD
enum States {
	RUNNING,
	ATTACKING,
	STUNNED,
	BLOCKING,
	BLOCK_IMPACT,
	SWORD_DEFLECT,
	DODGING,
	PARRY,
	PARRY_SUCCESS,
	PARRY_SWORD,
	}


# Configs
var state = States.RUNNING
var is_alive = true
var speed = 100000
var jump_power = 900
var gravity_power = 30
var pushback_multiplier = 0.0 # amount of increase pushback
var is_freezing = false


# Constants
@onready var anim_player = $AnimationPlayer
var ATTACK01_HITBOX = preload("res://nodes/hitboxes/attack01_hitbox.tscn")
var SUPER_HIT_HITBOX = preload("res://nodes/hitboxes/super_hit_hitbox.tscn")
var CHRAGE_PARTICLE = preload("res://nodes/particles/charging_particle.tscn")
const FRICTION = 0.06


func _ready():
	pass


func _physics_process(delta):
	# freeze chiichan for cool cutscene
	if is_freezing:
		return

	## stop chiichan from moving when she is ded
	## but chiichan still move from velocity she receive
	if not is_alive:
		move_and_slide()
		return

	if state not in [States.STUNNED, States.BLOCK_IMPACT, States.BLOCKING]:
		# On ground play run animation
		if is_on_floor():
			if not anim_player.is_playing():
				anim_player.play("run")

		# Jump
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				jump()
		elif Input.is_action_just_released("jump"):
			release_jump()

		# normal movement
		if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
			lerp_velocity_x()
		elif Input.is_action_pressed("move_left"):
			move_left(delta)
		elif Input.is_action_pressed("move_right"):
			move_right(delta)
		else:
			lerp_velocity_x()

	elif state == States.BLOCKING: # chiichan can slide block
		lerp_velocity_x()
	

	# Add gravity and calculate movements
	gravity()
	move_and_slide()


func _input(event):
	if not is_alive or is_freezing:
		return

	if state == States.STUNNED:
		return

	### Prevent chiichan from chaining actions
	### chiichan can chain dodge to attack, but not attack to dodge
	### chiichan can basically chain anything to attack but not vise versa

	if event.is_action_pressed("attack"):
		attack01()

	if event.is_action_pressed("block"):
		if state not in [States.BLOCK_IMPACT, States.ATTACKING, States.DODGING]:
			block()

	if event.is_action_pressed("dodge"):
		if state not in [States.BLOCK_IMPACT, States.ATTACKING]:
			dodge()


func lerp_velocity_x():
	velocity = velocity.lerp(Vector2(0, velocity.y), FRICTION)


func move_left(delta) ->  void:
	var calculated_speed = speed
	if state == States.ATTACKING:
		calculated_speed = speed / 2
	elif state == States.DODGING:
		calculated_speed = speed * 1.5
	velocity = Vector2(-calculated_speed * delta, velocity.y)


func move_right(delta) ->  void:
	var calculated_speed = speed
	if state == States.ATTACKING:
		calculated_speed = speed / 2
	elif state == States.DODGING:
		calculated_speed = speed * 1.5
	velocity = Vector2(calculated_speed * delta, velocity.y)


func spawn_hitbox01(): # used by AnimationPlayer
	var hitbox = ATTACK01_HITBOX.instantiate()
	hitbox.chiichan = self
	hitbox.position = $Attack01HitboxPos.position
	add_child(hitbox)


func spawn_super_hit_hitbox(): # used by AnimationPlayer
	var hitbox = SUPER_HIT_HITBOX.instantiate()
	hitbox.is_sword = true
	hitbox.position = $SuperHitHitboxPos.global_position
	$"..".add_child(hitbox)


func spawn_super_hit_hitbox_hand(): # used by AnimationPlayer
	var hitbox = SUPER_HIT_HITBOX.instantiate()
	hitbox.is_hand = true
	hitbox.position = $SuperHitHitboxPos.global_position
	$"..".add_child(hitbox)


func push(power: Vector2):
	power = (pushback_multiplier * power) + power
	if state in [States.BLOCKING, States.BLOCK_IMPACT, States.PARRY, States.PARRY_SUCCESS]:
		anim_player.play("parry_success")
		velocity += (power / 2)
		state = States.PARRY_SUCCESS
	else:
		anim_player.play("hurt")
		velocity += power

		## add more pushback next times chiichan got hit
		pushback_multiplier += 0.5
		state = States.STUNNED


func jump():
	state = States.RUNNING
	anim_player.play("jump")
	velocity += Vector2(0, -jump_power)


func release_jump():
	if velocity.y < 0: # while rising
		velocity = Vector2(velocity.x, 0)


func ded():
	is_alive = false
	$"%DedMenu".show_menu()


func sword_deflect():
	$"AnimationPlayer".play("sword_deflect")
	state = States.STUNNED
	velocity = Vector2(-500, 0)


func attack01():
	anim_player.play("attack01_2")


func set_state(_state) -> void:
	state = _state


func block():
	state = States.BLOCKING
	anim_player.play("block")


func dodge():
	state = States.DODGING
	anim_player.play("dodge")


func gravity():
	if not is_on_floor():
		velocity += Vector2(0, gravity_power)


func freeze() -> void: # used during super_hit
	is_freezing = true


func unfreeze() -> void: # used during super_hit
	is_freezing = false
	$AnimationPlayer.play("run")


func super_hit() -> void:
	freeze()
	$AnimationPlayer.play("super_hit_hand")


func spawn_charge_particle(): # used by AnimationPlayer
	var hitbox = CHRAGE_PARTICLE.instantiate()
	hitbox.time_before_queue_free = 0.4
	hitbox.z_index = 9
	add_child(hitbox)


func dodge_collision():
	collision_layer = 0b00000000000000001000
	collision_mask = 0b00000000000000000001


func normal_collision():
	collision_layer = 0b00000000000000000010
	collision_mask = 0b00000000000000000001


func _on_animation_player_animation_finished(anim_name):
	if anim_name in [
		"attack01",
		"hurt",
		"block",
		"block_impact",
		"attack01_2",
		"dodge",
		"sword_deflect",
		"parry_success",
		]:
		state = States.RUNNING
		anim_player.play("run")

		if pushback_multiplier >= 1.5:
			$"ChiichanPos/sprite".self_modulate = Color(1, 0.6, 0.5)
		elif pushback_multiplier >= 1:
			$"ChiichanPos/sprite".self_modulate = Color(0.9, 0.9, 0.4)
	elif anim_name in ["super_hit", "super_hit_hand"]:
		self.unfreeze()
		state = States.RUNNING


func _on_animation_player_animation_started(anim_name):
	if anim_name == "jump":
		$"ChiichanPos/sprite".modulate = Color(1, 1, 1)

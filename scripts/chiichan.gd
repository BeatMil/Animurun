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
var is_strong_wind = false
var can_jump = true


# Constants
@onready var anim_player = $AnimationPlayer
var ATTACK01_HITBOX = preload("res://nodes/hitboxes/attack01_hitbox.tscn")
var SUPER_HIT_HITBOX = preload("res://nodes/hitboxes/super_hit_hitbox.tscn")
var CHRAGE_PARTICLE = preload("res://nodes/particles/charging_particle.tscn")
var WAVEDASH_PARTICLE = preload("res://nodes/particles/wavedash_particle.tscn")
var ORA_ORA = preload("res://nodes/ora_ora.tscn")
var FAIL_HITBOX = preload("res://nodes/hitboxes/fail_hitbox.tscn")
const FRICTION = 0.06


func _ready():
	pass
	#if Config.checkpoint == -1:
	#	$AnimationPlayer2.play("intro")


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
		if Input.is_action_pressed("jump"):
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
	
	if is_strong_wind:
		if velocity.x <= (-speed) * delta: # Cap the pushing wind speed
			pass
		else:
			velocity.x += (-speed*0.9) * delta

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
		if state not in [States.ATTACKING, States.BLOCK_IMPACT]:
			parry()

	if event.is_action_pressed("dodge"):
		dodge()


func lerp_velocity_x():
	velocity = velocity.lerp(Vector2(0, velocity.y), FRICTION)


func move_left(delta) ->  void:
	var calculated_speed = speed
	if state == States.ATTACKING:
		calculated_speed = speed * 0.5
	elif state == States.DODGING:
		calculated_speed = speed * 1.5
	velocity = Vector2(-calculated_speed * delta, velocity.y)


func move_right(delta) ->  void:
	var calculated_speed = speed
	if state == States.ATTACKING:
		calculated_speed = speed * 0.5
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


func push(power: Vector2): # determine if chiichan get push or parry
	power = (pushback_multiplier * power) + power
	if state in [States.PARRY]:
		anim_player.play("parry_success")
		state = States.PARRY_SUCCESS
	elif state in [States.BLOCKING, States.BLOCK_IMPACT]:
		anim_player.play("block_impact_hand")
		velocity += (power / 2)
	else:
		anim_player.play("hurt")
		velocity += power

		## add more pushback next times chiichan got hit
		pushback_multiplier += 0.5
		state = States.STUNNED


func jump():
	if can_jump:
		state = States.RUNNING
		anim_player.play("jump")
		velocity += Vector2(0, -jump_power)


func release_jump():
	if velocity.y < 0: # while rising
		velocity = Vector2(velocity.x, 0)


func ded():
	is_alive = false
	$"..".save_checkpoint()
	$"%DedMenu".show_menu()


func sword_deflect():
	$"AnimationPlayer".play("sword_deflect")
	state = States.STUNNED
	velocity = Vector2(-500, 0)


func attack01():
	anim_player.play("attack01_2")


func set_state(_state) -> void:
	state = _state


func parry():
	anim_player.play("parry")


func dodge():
	if state == States.RUNNING:
		dodge_chain()
	else:
		anim_player.play("dodge")


func dodge_chain():
	anim_player.stop() # uncomment this to chain dodge
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


func ora_ora() -> void:
	freeze()
	$AnimationPlayer.play("wavedash")
	spawn_ora_ora()


func spawn_ora_ora() -> void:
	var ora = ORA_ORA.instantiate()
	ora.position += Vector2(0, -300)
	ora.connect("failed", ora_ora_fail)
	ora.connect("successful", ora_ora_success)
	# connect 2 more signals here
	call_deferred("add_child", ora)


func ora_ora_success() -> void:
	$AnimationPlayer.play("ewgf")
	$AnimationPlayer2.play("wavedash_sfx", -1 , 3)
	$"..".smol_shake_offset()


func ora_ora_fail() -> void:
	unfreeze()
	$"..".unfreeze() # unfreeze background
	spawn_fail_hitbox()
	push(Vector2(-2000, 0))


func spawn_fail_hitbox() -> void: # free slime from freeze
	var fail = FAIL_HITBOX.instantiate()
	fail.position = $Attack01HitboxPos.position
	call_deferred("add_child", fail)


func play_wavedash(_speed: float) -> void:
	anim_player.play("wavedash", -1, _speed)


func stop_wavedash_sfx() -> void:
	$AnimationPlayer2.stop()


func stop_moving() -> void:
	is_freezing = true
	anim_player.play("stand_still")


func play_stage1_clear() -> void:
	is_freezing = true
	anim_player.play("stage1_clear")


func play_stage1_clear_b() -> void:
	is_freezing = true
	anim_player.play("stage1_clear_b")


func spawn_wavedash_particle(): # used by AnimationPlayer
	var hitbox = WAVEDASH_PARTICLE.instantiate()
	hitbox.time_before_queue_free = 0.9
	hitbox.z_index = 9
	hitbox.position += Vector2(-80, 120)
	add_child(hitbox)


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


func display_health():
		if pushback_multiplier >= 1:
			$"ChiichanPos/sprite".self_modulate = Color(1, 0.6, 0.5)
		elif pushback_multiplier >= 0.5:
			$"ChiichanPos/sprite".self_modulate = Color(0.89, 0.87, 0.46)
		else:
			$"ChiichanPos/sprite".self_modulate = Color(1, 1, 1)


func _on_animation_player_animation_finished(anim_name):
	if anim_name in [
		"attack01",
		"hurt",
		"parry",
		"block_impact",
		"block_impact_hand",
		"attack01_2",
		"dodge",
		"sword_deflect",
		"parry_success",
		]:
		state = States.RUNNING
		anim_player.play("run")

		display_health()
	elif anim_name in ["super_hit", "super_hit_hand", "ewgf"]:
		self.unfreeze()
		state = States.RUNNING
	elif anim_name == "stage1_clear":
		$"../BossStealBigSword".play_steal_sword()
	elif anim_name == "stage1_clear_b":
		$"..".go_to_next_stage()


func _on_animation_player_animation_started(anim_name):
	if anim_name == "jump":
		$"ChiichanPos/sprite".modulate = Color(1, 1, 1)
	
	if anim_name == "parry_success":
		display_health()


extends CharacterBody2D


@export var default_pos: Node


# Beat's own state machine XD
enum States {RUNNING, ATTACKING, STUNNED, BLOCKING, BLOCK_IMPACT, SWORD_DEFLECT, DODGING}


# Configs
var state = States.RUNNING
var is_alive = true
var speed = 100000
var jump_power = 900
var gravity_power = 30
var pushback_multiplier = 0.0 # amount of increase pushback


# Constants
@onready var anim_player = $AnimationPlayer
var ATTACK01_HITBOX = preload("res://nodes/hitboxes/attack01_hitbox.tscn")
const FRICTION = 0.1


func _ready():
	pass


func _physics_process(delta):
	## stop chiichan from moving when she is ded
	## but chiichan still move from velocity she receive
	if not is_alive:
		move_and_slide()
		return

	if state not in [States.STUNNED, States.BLOCK_IMPACT]:
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
	

	# Add gravity and calculate movements
	gravity()
	move_and_slide()


func _input(event):
	if not is_alive:
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
	velocity = Vector2(-calculated_speed * delta, velocity.y)


func move_right(delta) ->  void:
	var calculated_speed = speed
	if state == States.ATTACKING:
		calculated_speed = speed / 2
	velocity = Vector2(calculated_speed * delta, velocity.y)


func spawn_hitbox01(): # used by AnimationPlayer
	var hitbox = ATTACK01_HITBOX.instantiate()
	hitbox.chiichan = self
	hitbox.position = $Attack01HitboxPos.position
	add_child(hitbox)


func push(power: Vector2):
	power = (pushback_multiplier * power) + power
	if state == States.BLOCKING or state == States.BLOCK_IMPACT:
		anim_player.play("block_impact")
		velocity += (power / 2)
		state = States.BLOCK_IMPACT
	else:
		anim_player.play("hurt")
		velocity += power

		## add more pushback next times chiichan got hit
		pushback_multiplier += 0.5
		state = States.STUNNED
	


func jump():
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
	state = States.ATTACKING
	anim_player.play("attack01_2")


func block():
	state = States.BLOCKING
	anim_player.play("block")


func dodge():
	state = States.DODGING
	anim_player.play("dodge")


func gravity():
	if not is_on_floor():
		velocity += Vector2(0, gravity_power)


func dodge_collision():
	collision_layer = 0b00000000000000001000
	collision_mask = 0b00000000000000000001


func normal_collision():
	collision_layer = 0b00000000000000000010
	collision_mask = 0b00000000000000000001


func _on_animation_player_animation_finished(anim_name):
	if anim_name in ["attack01", "hurt", "block", "block_impact", "attack01_2", "dodge", "sword_deflect"]:
		state = States.RUNNING
		anim_player.play("run")

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


# Constants
@onready var anim_player = $AnimationPlayer
var ATTACK01_HITBOX = preload("res://nodes/hitboxes/attack01_hitbox.tscn")
const FRICTION = 0.1


func _ready():
	pass


func _physics_process(delta):
	if state != States.STUNNED:
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
			velocity = Vector2(-speed * delta, velocity.y)
		elif Input.is_action_pressed("move_right"):
			velocity = Vector2(speed * delta, velocity.y)
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

	if event.is_action_pressed("attack"):
		attack01()

	if event.is_action_pressed("block"):
		block()

	if event.is_action_pressed("dodge"):
		dodge()


func lerp_velocity_x():
	velocity = velocity.lerp(Vector2(0, velocity.y), FRICTION)


func spawn_hitbox01(): # used by AnimationPlayer
	var hitbox = ATTACK01_HITBOX.instantiate()
	hitbox.chiichan = self
	hitbox.position = $Attack01HitboxPos.position
	add_child(hitbox)


func push(power: Vector2):
	if state == States.BLOCKING:
		anim_player.play("block_impact")
	else:
		anim_player.play("hurt")
	
	state = States.STUNNED

	velocity += power

	# Set linear_velocity to ZERO
	# Make it easier to control how far chiichan would fly 
	# When she collides while moving and while stay still
	# linear_velocity = Vector2.ZERO
	# apply_impulse(power)


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
	velocity = Vector2.ZERO


func attack01():
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
	if anim_name in ["attack01", "hurt", "block", "block_impact", "attack01_2", "dodge"]:
		state = States.RUNNING
		anim_player.play("run")

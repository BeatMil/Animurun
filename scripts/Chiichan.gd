extends RigidBody2D


@export var default_pos: Node


# Beat's own state machine XD
enum States {RUNNING, ATTACKING, STUNNED, BLOCKING, BLOCK_IMPACT, SWORD_DEFLECT}


# Configs
var state = States.RUNNING
var is_alive = true
var can_move_to_default_pos = false
var speed = Vector2(100, 0)


# Constants
@onready var anim_player = $AnimationPlayer
var ATTACK01_HITBOX = preload("res://nodes/hitboxes/attack01_hitbox.tscn")


func _ready():
	pass # Replace with function body.


func _integrate_forces(_state):
	if position.x < default_pos.position.x and can_move_to_default_pos and is_alive:
		linear_velocity = speed


func _input(event):
	if not is_alive:
		return

	if state == States.STUNNED:
		return

	if event.is_action_pressed("ui_accept"):
		attack01()

	if event.is_action_pressed("block"):
		block()


func spawn_hitbox01(): # used by AnimationPlayer
	var hitbox = ATTACK01_HITBOX.instantiate()
	hitbox.chiichan = self
	hitbox.position = $Attack01HitboxPos.position
	add_child(hitbox)


func hit_by_slime():
	if state == States.BLOCKING:
		anim_player.play("block_impact")
	else:
		anim_player.play("hurt")
	
	state = States.STUNNED

	# Set linear_velocity to ZERO
	# Make it easier to control how far chiichan would fly 
	# When she collides while moving and while stay still
	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2(-1500, -100))

	can_move_to_default_pos = false


func hit_by_speed_slime():
	if state == States.BLOCKING:
		anim_player.play("block_impact")
	else:
		anim_player.play("hurt")

	state = States.STUNNED

	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2(-2000, -100))

	can_move_to_default_pos = false


func hit_by_rocky():
	if state == States.BLOCKING:
		anim_player.play("block_impact")
	else:
		anim_player.play("hurt")
	
	state = States.STUNNED

	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2(-2000, -100))

	can_move_to_default_pos = false


func ded():
	is_alive = false
	can_move_to_default_pos = false
	apply_impulse(Vector2(-800, -100))
	$"%DedMenu".show_menu()


func sword_deflect():
	$"AnimationPlayer".play("sword_deflect")
	state = States.STUNNED
	apply_impulse(Vector2(-900, -100))


func attack01():
	anim_player.play("attack01_2")


func block():
	state = States.BLOCKING
	anim_player.play("block")


func _on_animation_player_animation_finished(anim_name):
	if anim_name in ["attack01", "hurt", "block", "block_impact", "attack01_2"]:
		state = States.RUNNING
		can_move_to_default_pos = true
		anim_player.play("run")

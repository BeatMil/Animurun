extends RigidBody2D


@export var default_pos: Node


# Configs
var is_alive = true
var can_move_to_default_pos = false
var speed = Vector2(100, 0)


# Constants
@onready var anim_player = $AnimationPlayer
var ATTACK01_HITBOX = preload("res://Nodes/Hitboxes/attack01_hitbox.tscn")


func _ready():
	pass # Replace with function body.


func _integrate_forces(_state):
	if position.x < default_pos.position.x and can_move_to_default_pos and is_alive:
		linear_velocity = speed


func _input(event):
	if not is_alive:
		return

	if event.is_action_pressed("ui_accept"):
		anim_player.play("attack01")


func spawn_hitbox01():
	var hitbox = ATTACK01_HITBOX.instantiate()
	hitbox.position = $Attack01HitboxPos.position
	add_child(hitbox)


func hit_by_slime():
	anim_player.play("hurt")

	# Set linear_velocity to ZERO
	# Make it easier to control how far chiichan would fly 
	# When she collides while moving and while stay still
	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2(-1500, -100))

	can_move_to_default_pos = false


func hit_by_speed_slime():
	anim_player.play("hurt")

	# Set linear_velocity to ZERO
	# Make it easier to control how far chiichan would fly 
	# When she collides while moving and while stay still
	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2(-2000, -100))

	can_move_to_default_pos = false


func ded():
	is_alive = false
	can_move_to_default_pos = false
	apply_impulse(Vector2(-800, -100))
	$"%DedMenu".show_menu()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack01" or anim_name == "hurt":
		anim_player.play("run")
		can_move_to_default_pos = true

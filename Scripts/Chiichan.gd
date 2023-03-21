extends RigidBody2D


# Configs
var is_alive = true


# Constants
@onready var anim_player = $AnimationPlayer
var ATTACK01_HITBOX = preload("res://Nodes/Hitboxes/attack01_hitbox.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if not is_alive:
		return

	if event.is_action_pressed("ui_accept"):
		anim_player.play("attack01")


func spawn_hitbox01():
	var hitbox = ATTACK01_HITBOX.instantiate()
	hitbox.position = $Attack01HitboxPos.position
	add_child(hitbox)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack01" or anim_name == "hurt":
		anim_player.play("run")

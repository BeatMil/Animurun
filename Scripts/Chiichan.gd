extends RigidBody2D


@onready var anim_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_accept"):
		anim_player.play("attack01")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack01":
		anim_player.play("run")

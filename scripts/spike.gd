extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		$"../CameraWrap/CameraPlayer".play("smol_shake_2")
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-2000, -1000))


func _on_timer_timeout():
	$AnimationPlayer.play("spike")

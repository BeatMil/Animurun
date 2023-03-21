extends Node


func _ready():
	pass # Replace with function body.


func _on_ded_wall_area_2d_body_entered(body):
	if body.is_in_group("chiichan"):
		# play ded particle and animation
		$"AnimationPlayer".play("ded")
		$"%CameraPlayer".play("shake")

		body.is_alive = false # chiichan is ded

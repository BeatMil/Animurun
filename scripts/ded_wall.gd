extends Node


func _on_ded_wall_area_2d_body_entered(body):
	if body.is_in_group("chiichan"):
		# play ded particle and animation
		$"AnimationPlayer".play("ded_sfx")
		$"%CameraPlayer".play("shake")

		# stop spawning attacks
		$"..".enemy_spawn_order.clear() 

		if body.is_alive:
			body.ded() # chiichan is ded

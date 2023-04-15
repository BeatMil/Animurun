extends Area2D


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.activate_boom_then()
		$"../CameraWrap/CameraPlayer".play("smol_shake_2")


func _on_timer_timeout():
	queue_free()

extends Area2D


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.activate_boom_then()


func _on_timer_timeout():
	queue_free()

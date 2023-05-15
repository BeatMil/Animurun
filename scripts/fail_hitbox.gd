extends Area2D


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.custom_integrator = false
		body.apply_impulse(Vector2(-2000, 2000))

		print("I found slime!!")


func _on_timer_timeout():
	queue_free()

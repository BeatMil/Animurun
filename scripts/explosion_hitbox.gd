extends Area2D


func _on_body_entered(body):
	body.push(Vector2(-9000, -1900))


func _on_timer_timeout():
	queue_free()

extends Node2D


signal ded


func _on_area_2d_body_entered(body):
	if body.is_in_group("chiichan"):
		body.push(Vector2(-2000, 0))


func _queue_free():
	emit_signal("ded")
	queue_free()

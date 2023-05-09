extends Area2D


# Signals
signal ded



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "waterfall":
		emit_signal("ded")
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		body.push(Vector2(-2000, -100))

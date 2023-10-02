extends Node2D


signal ded


func _on_area_2d_body_entered(body):
	print(body)
	if body.is_in_group("chiichan"):
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-2000, -100))


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		$AnimationPlayer.play("shoot")
	elif anim_name == "shoot":
		emit_signal("ded")
		queue_free()

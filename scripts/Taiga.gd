extends Area2D


func push_chiichan():
	$AnimationPlayer.play("push")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "push":
		$AnimationPlayer.play("idle")


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		body.push(Vector2(-4000, 0))
		push_chiichan()

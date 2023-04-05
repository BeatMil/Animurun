extends Area2D


func push_chiichan():
	$AnimationPlayer.play("push")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "push":
		$AnimationPlayer.play("idle")

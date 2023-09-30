extends RigidBody2D


func push_chiichan():
	$AnimationPlayer.play("attack")


func play_attack():
	$AnimationPlayer.play("attack")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("idle")


func _on_body_entered(body):
	if body.is_in_group("slime"):
		$AnimationPlayer.play("hurt")


extends Sprite2D


func play_attack():
	$AnimationPlayer.play("attack")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("RESET")

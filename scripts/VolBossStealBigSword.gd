extends Sprite2D


func play_steal_sword():
	$AnimationPlayer.play("steal_sword")

func despawn_sword():
	$"../Boss/sword".queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "steal_sword":
		$"../Chiichan".play_stage1_clear_b()

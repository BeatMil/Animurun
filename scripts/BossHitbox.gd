extends Area2D


func _on_body_entered(body):
	# this is such a bad code... XD
	# I swear i'll organise better next game 
	if body.is_in_group("slime"):
		if body.is_boom_slime:
			body.linear_velocity = Vector2.ZERO
			body.play_hit_finalboss()
			$"..".kaisouko_hp = -1
			set_deferred("monitoring", false)
			await get_tree().create_timer(1, false).timeout
			$"..".spawner()
			$"../Chiichan".can_jump = false

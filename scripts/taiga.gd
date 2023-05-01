extends RigidBody2D


func push_chiichan() -> void:
	$AnimationPlayer.play("push")


func hurt() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hurt")


func freeze() -> void:
	$AnimationPlayer.pause()


func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "push" or anim_name == "hurt":
		$AnimationPlayer.play("idle")
	elif anim_name == "mad":
		$"..".spawner()


func _on_body_entered(body) -> void:
	if body.is_in_group("chiichan"):
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-4000, 0))
		push_chiichan()

	if body.is_in_group("slime"):
		body.apply_impulse(Vector2(-1000, -1000))
		body.apply_torque_impulse(-100000)
		body.turn_off_all_collision()
		body.let_blue_spark_go()
		body.hurt()
		hurt()
		$"..".taiga_hp -= 1 # progress through tutorial phase

		if body.is_boom_slime: # hit by chiichan super_hit
			$AnimationPlayer.queue("mad")

			# unfreeze stuffs
			$"../ParallaxBackground".unfreeze()
			$"../BackgroundDim".unfreeze()
			$"../CameraWrap/CameraPlayer".play_backwards("super_hit_zoom")

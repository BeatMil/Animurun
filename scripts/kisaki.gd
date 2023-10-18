extends RigidBody2D


var is_angry = false


func push_chiichan(): # used by wall.gd
	$AnimationPlayer.play("attack")


func play_attack():
	$AnimationPlayer.play("attack")


func play_angry():
	$AnimationPlayer.play("angry")


func freeze() -> void:
	$AnimationPlayer.pause()


# Used by $AnimationPlayer.play("angry")
func continue_spawner():
	$"..".spawner()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("idle")


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.apply_impulse(Vector2(-1000, -1000))
		body.apply_torque_impulse(-100000)
		body.turn_off_all_collision()
		body.let_blue_spark_go() # in case if slime is for cutscene

		$AnimationPlayer.stop()
		$AnimationPlayer.play("hurt")
		$"..".kisaki_hp -= 1

		if body.is_boom_slime: # hit by chiichan super_hit
			$AnimationPlayer.queue("angry")
			# unfreeze stuffs
			$"..".unfreeze()


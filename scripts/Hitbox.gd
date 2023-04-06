extends Area2D

var chiichan


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.is_moving = false
		body.turn_hit_boss_collision()
		body.hurt()

		if body.is_throw_slime:
			body.apply_impulse(Vector2(3000, -2500))
			body.apply_torque_impulse(100000)
		else:
			body.apply_impulse(Vector2(2000, -2000))
			body.apply_torque_impulse(100000)

	if body.is_in_group("rocky"):
		chiichan.sword_deflect()
		body.hurt()

	if body.is_in_group("bomby"):
		body.jump_off_screen()
		chiichan.push(Vector2(-9000, -1900))

	if body.is_in_group("taiga"):
		body.push_chiichan()
		chiichan.sword_deflect()

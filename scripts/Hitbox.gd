extends Area2D

var chiichan


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.is_moving = false
		body.turn_off_all_collision()
		body.apply_impulse(Vector2(2000, -2000))
		body.apply_torque_impulse(100000)
		body.get_node("AnimationPlayer").play("hurt")

	if body.is_in_group("rocky"):
		chiichan.sword_deflect()
		body.hurt()

	if body.is_in_group("bomby"):
		body.jump_off_screen()
		chiichan.push(Vector2(-9000, -1900))


func _on_area_entered(area):
	print(area)
	if area.is_in_group("taiga"):
		area.push_chiichan()
		chiichan.sword_deflect()


extends RigidBody2D


signal ded


var rng = RandomNumberGenerator.new()


func _ready():
	if rng.randi_range(0, 1) == 1:
		apply_impulse(Vector2(-2000, 1000))
		$"AnimationPlayer".play("shoot")
	else:
		apply_impulse(Vector2(-4000, 2000))
		$"AnimationPlayer".play("shoot_fast")


func hurt():
	$"AnimationPlayer".play("hurt")


func turn_hit_boss_collision():
	collision_layer = 0b00000000000000000100
	collision_mask = 0b00000000000000010000


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		# push slime
		if body.state == body.States.PARRY:
			turn_hit_boss_collision()
			hurt()

			linear_velocity = Vector2.ZERO
			await get_tree().create_timer(0.01, false).timeout
			apply_impulse(Vector2(3000, -1000))
			apply_torque_impulse(100000)

		# push chiichan
		body.push(Vector2(-1500, -100))


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")

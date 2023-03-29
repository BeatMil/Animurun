extends RigidBody2D


var speed: Vector2 = Vector2(-1000, 0)


# Config
var is_moving = true


# Signals
signal ded


func _integrate_forces(_state):
	if is_moving:
		linear_velocity = speed


func activate_speed():
	$"AnimationPlayer".play("speed")
	speed = speed * 2


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		# slime got pushed away
		is_moving = false
		turn_off_all_collision()
		apply_impulse(Vector2(1000, -1000))
		apply_torque_impulse(100000)
		$"AnimationPlayer".play("hurt")

		# chiichan got pushed away
		body.push(Vector2(-2000, -100))


func hurt(): # rocky got him by greatsword
	$"AnimationPlayer".play("hurt")


func turn_off_all_collision():
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")
	queue_free()

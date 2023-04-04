extends RigidBody2D


var speed: Vector2 = Vector2(-1000, 0)


# Config
var is_moving = true
var	is_speed_bomby = true


# Signals
signal ded


func _integrate_forces(_state):
	if is_moving:
		linear_velocity = speed


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		jump_off_screen()

		# chiichan got pushed away
		body.push(Vector2(-9000, -1900))


func activate_speed():
	$"AnimationPlayer".play("speed")
	is_speed_bomby = true
	speed = speed * 2


func hurt(): # bomby got him by greatsword, hitbox01.gd
	$"AnimationPlayer".play("hurt")


func jump_off_screen():
		# slime got pushed away
		is_moving = false
		turn_off_all_collision()
		apply_impulse(Vector2(1000, -1000))
		apply_torque_impulse(100000)
		$"AnimationPlayer".play("hurt")


func throw_bomb() -> void:
	is_moving = false
	$ShapePlayer.play("circle_shape")
	apply_impulse(Vector2(-2000, -2000))


func turn_off_all_collision():
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")
	queue_free()

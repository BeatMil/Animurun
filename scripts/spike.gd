extends RigidBody2D


# Signal
signal ded


# Configs
var is_moving = false
var moving_speed = Vector2(-800, 0)


func _integrate_forces(_state):
	if is_moving:
		linear_velocity = moving_speed
	else:
		linear_velocity = Vector2.ZERO


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		$"../CameraWrap/CameraPlayer".play("smol_shake_2")
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-2000, -1000))


func set_is_moving(_value: bool) -> void:
	is_moving = _value


func _on_animation_player_animation_started(anim_name):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")

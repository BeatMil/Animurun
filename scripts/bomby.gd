extends RigidBody2D


# Config
var speed: Vector2 = Vector2(-1000, 0)
var is_moving = true
var	is_speed_bomby = true
var	is_throw_bomb = false


# Preloads
var PARTICLE01 = preload("res://nodes/particles/particle01.tscn")
var EXPLOSION_HITBOX = preload("res://nodes/hitboxes/explosion_hitbox.tscn")


# Signals
signal ded
signal shake


func _ready():
	connect("shake", $"..".smol_shake)


func _integrate_forces(_state):
	if is_moving:
		linear_velocity = speed


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		jump_off_screen()

		# chiichan got pushed away
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-9000, -1900))
	
	if body.is_in_group("ground") and is_throw_bomb:
		spawn_hitbox()
		jump_off_screen()


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
		spawn_particle() # vfx
		emit_signal("shake")


func spawn_particle() -> void:
	var particle = PARTICLE01.instantiate()
	particle.position = position
	$"..".call_deferred("add_child", particle)


func spawn_hitbox() -> void:
	var explosion = EXPLOSION_HITBOX.instantiate()
	explosion.position = position
	$"..".call_deferred("add_child", explosion)


func throw_bomb(power: Vector2) -> void:
	is_moving = false
	is_throw_bomb = true
	$ShapePlayer.play("circle_shape")
	apply_impulse(power)


func turn_off_all_collision():
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")
	queue_free()

extends RigidBody2D


var speed: Vector2 = Vector2(-1000, 0)
@onready var chiichan = $"../Chiichan"
var BLUE_SPARK = preload("res://nodes/particles/blue_spark.tscn")


# Config
var is_moving = true
var is_throw_slime = false
var is_speed_slime = false
var is_boom_slime = false # turn this on when spawnning


# Signals
signal ded


func _integrate_forces(_state):
	if is_moving:
		linear_velocity = speed


func activate_speed():
	$"AnimationPlayer".play("speed")
	is_speed_slime = true
	speed = speed * 2


func activate_boom(): # hitbox.gd run this
	disconnect("ded", $"..".spawner)
	chiichan.super_hit()
	self.is_moving = false
	self.linear_velocity = Vector2.ZERO
	self.angular_velocity = 0
	self.custom_integrator = true
	$"../ParallaxBackground".freeze()
	$"../Taiga".freeze()
	$"../BackgroundDim".freeze()
	# camera.zoom
	# self.shining_meteo()
	# self.push_to_taigo
	pass


func activate_boom_then(): # hitbox.gd run this
	self.apply_impulse(Vector2(2000, 1000))
	spawn_blue_spark()
	await get_tree().create_timer(0.1, false).timeout
	self.apply_torque_impulse(100000)


func spawn_blue_spark() -> void:
	var particle = BLUE_SPARK.instantiate()
	particle.node_to_follow =  self
	$"..".add_child(particle)


func let_blue_spark_go() -> void:
	if $"..".has_node("blue_spark"):
		$"../blue_spark".is_following = false


func hurt():
	$"AnimationPlayer".play("hurt")


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		# slime got pushed away
		is_moving = false
		turn_off_all_collision()
		apply_impulse(Vector2(1000, -1000))
		apply_torque_impulse(100000)
		hurt()

		# chiichan got pushed away
		if is_speed_slime:
			body.push(Vector2(-2000, -100))
		else:
			body.push(Vector2(-1500, -100))


func throw_slime(power: Vector2) -> void:
	is_moving = false
	is_throw_slime = true
	apply_impulse(power)
	await get_tree().create_timer(0.1).timeout
	apply_torque_impulse(-100000)


func turn_off_all_collision():
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000


func turn_hit_boss_collision():
	collision_layer = 0b00000000000000000100
	collision_mask = 0b00000000000000010000


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")
	queue_free()

extends RigidBody2D

# Signals
signal ded

# Configs
var speed: Vector2 = Vector2(-2500, 0)
var is_moving = true

# Preloads
var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")


func _ready():
	go()
	pass


func _integrate_forces(_state):
	pass
	# if is_moving:
	# 	linear_velocity = speed


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")


func go() -> void:
	apply_central_impulse(speed)


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		body.push(Vector2(-9000, -1900))
		apply_central_impulse(Vector2(1500, 0))
		$AnimationPlayer.play("outro")

	if body.is_in_group("ground"):
		apply_central_impulse(Vector2(-1500, 0))

	$"../CameraWrap/CameraPlayer".play("smol_shake")
	$"AnimationPlayer".play("explode")
	turn_off_all_collision()
	spawn_hit_spark()


func spawn_hit_spark() -> void:
	var hit = HIT_SPARK.instantiate()
	hit.position.y += 200
	add_child(hit)


func _on_timer_timeout():
	go()


func turn_off_all_collision() -> void:
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000

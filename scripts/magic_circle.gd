extends RigidBody2D

# Signals
signal ded


# Configs
var speed: Vector2 = Vector2(-2500, 0)
var is_faster = false
var bounce_count = 0


# Preloads
var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")


func _ready():
	go()
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")


func go() -> void:
	apply_central_impulse(speed)


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		body.push(Vector2(-9000, -1900))
		if is_faster:
			apply_central_impulse(Vector2(5000, -300))
		else:
			apply_central_impulse(Vector2(3000, -300))
		turn_hit_boss_collision()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("bounce")
		bounce_count += 1
	elif body.is_in_group("boss"):
		if bounce_count >= 3:
			# hit boss
			turn_off_all_collision()
			$AnimationPlayer.play("explode")
			body.play_hurt()
		else:
			body.play_attack3()
			if is_faster:
				apply_central_impulse(Vector2(-5000, 0))
			else:
				apply_central_impulse(Vector2(-3000, 0))
			turn_on_normal_collision()
			$AnimationPlayer.stop()
			$AnimationPlayer.play("bounce")
	else:
		$AnimationPlayer.play("ground_hit")


	# if body.is_in_group("ground"):
	# 	apply_central_impulse(Vector2(-1500, 0))

	$"../CameraWrap/CameraPlayer".play("smol_shake")
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


func turn_on_normal_collision() -> void:
	collision_layer = 0b00000000000000000100
	collision_mask = 0b00000000000000000011


func turn_hit_boss_collision():
	collision_layer = 0b00000000000000000100
	collision_mask = 0b00000000000000010001


func _queue_free():
	emit_signal("ded")
	queue_free()

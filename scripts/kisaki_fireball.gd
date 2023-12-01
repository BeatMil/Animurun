extends RigidBody2D


signal ded


var rng = RandomNumberGenerator.new()

var is_boom_slime = false # ALWAYS FALSE
# I should have code better than this... XD


var RED_SPARK = preload("res://nodes/particles/red_spark.tscn")


func _ready():
	if rng.randi_range(0, 1) == 1:
		apply_impulse(Vector2(-2000, 1000))
		$"AnimationPlayer".play("shoot")
	else:
		apply_impulse(Vector2(-3000, 2000))
		$"AnimationPlayer".play("shoot_fast")
		spawn_red_spark()


func hurt():
	$"AnimationPlayer".play("hurt")


func turn_hit_boss_collision():
	collision_layer = 0b00000000000000000100
	collision_mask = 0b00000000000000010000


func turn_off_all_collision():
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000


func spawn_red_spark() -> void:
	var particle = RED_SPARK.instantiate()
	particle.node_to_follow =  self
	$"..".add_child(particle)


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		hurt()
		linear_velocity = Vector2.ZERO

		if body.state == body.States.PARRY:
			# bounce to boss if chiichan parried
			turn_hit_boss_collision()
			await get_tree().create_timer(0.01, false).timeout
			apply_impulse(Vector2(3000, -1000))
			apply_torque_impulse(100000)
		else:
			# small bounce and fall off the screen
			turn_off_all_collision()
			await get_tree().create_timer(0.01, false).timeout
			apply_impulse(Vector2(100, -1000))
			apply_torque_impulse(100000)


		# push chiichan
		body.push(Vector2(-1500, -100))


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")
	queue_free()


func let_blue_spark_go() -> void: # keep here or break
	pass

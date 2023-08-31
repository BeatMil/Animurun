extends RigidBody2D


# preloads
var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")
var SWORD = preload("res://nodes/sword.tscn")

var rng = RandomNumberGenerator.new()


func push_chiichan() -> void:
	$AnimationPlayer.play("push")


func play(anim_name: String) -> void:
	$AnimationPlayer.play(anim_name)


func hurt() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hurt")


func freeze() -> void:
	$AnimationPlayer.pause()


func _spawn_hit_spark() -> void:
	var hitbox = HIT_SPARK.instantiate()
	var offset_x = rng.randi_range(-100, 0)
	var offset_y = rng.randi_range(-100, 100)
	hitbox.position += Vector2(offset_x, offset_y)
	add_child(hitbox)
	print("SPAWN HITSPARK!!!")


func stop_chiichan_from_moving_stage01_outro() -> void:
	$"../Chiichan".stop_moving() # stop chiichan from moving to do stage01 outro


func _spawn_sword() -> void:
	var sword = SWORD.instantiate()
	sword.name = "sword"
	add_child(sword)
	$"../ParallaxBackground".freeze()
	stop_chiichan_from_moving_stage01_outro()


func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name in ["push", "hurt", "pre_attack", "pre_attack_2"]:
		$AnimationPlayer.play("idle")
	elif anim_name == "mad":
		$"..".spawner()


func _on_body_entered(body) -> void:
	if body.is_in_group("chiichan"):
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-4000, 0))
		push_chiichan()

	if body.is_in_group("slime"):
		body.apply_impulse(Vector2(-1000, -1000))
		body.apply_torque_impulse(-100000)
		body.turn_off_all_collision()
		body.let_blue_spark_go()
		body.hurt()
		hurt()
		$"..".taiga_hp -= 1 # progress through tutorial phase

		if body.is_speed_slime: # hit by ewgf
			$AnimationPlayer.queue("explode")
			# unfreeze stuffs
			$"..".unfreeze()
			$"..".stop_playing_ost()
		elif body.is_boom_slime: # hit by chiichan super_hit
			$AnimationPlayer.queue("mad")
			# unfreeze stuffs
			$"..".unfreeze()

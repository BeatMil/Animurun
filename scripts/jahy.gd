extends RigidBody2D


var is_angry = false
var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")
var SWORD = preload("res://nodes/sword.tscn")
var SLIME = preload("res://nodes/slime.tscn")


var rng = RandomNumberGenerator.new()


func push_chiichan(): # used by wall.gd
	$AnimationPlayer.play("attack")


func play_attack():
	$AnimationPlayer.play("attack")


func play_attack2():
	$AnimationPlayer.play("attack_2")


func play_attack3():
	$AnimationPlayer.play("attack_3")
	

func play_hurt():
	$AnimationPlayer.play("hurt")


func play_angry():
	$AnimationPlayer.play("angry")


func play_explode():
	$AnimationPlayer.play("explode")


func freeze() -> void:
	$AnimationPlayer.pause()


# Used by $AnimationPlayer.play("angry")
func continue_spawner():
	$"..".spawner()


func _spawn_sword() -> void:
	var sword = SWORD.instantiate()
	sword.name = "sword"
	add_child(sword)


func spawn_hit_spark() -> void: # Used by $AnimationPlayer.play 'explode'
	var hitbox = HIT_SPARK.instantiate()
	var offset_x = rng.randi_range(-100, 0)
	var offset_y = rng.randi_range(-100, 100)
	hitbox.position += Vector2(offset_x, offset_y)
	add_child(hitbox)


func _on_animation_player_animation_finished(anim_name):
	if anim_name in ["attack", "attack_2", "attack_3"]:
		$AnimationPlayer.play("idle")
	elif anim_name == "explode":
		$"../ParallaxBackground".freeze()
		$"../Chiichan".stop_moving()


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.apply_impulse(Vector2(-1000, -1000))
		body.apply_torque_impulse(-100000)
		body.turn_off_all_collision()
		body.let_blue_spark_go() # in case if slime is for cutscene

		$AnimationPlayer.stop()
		$AnimationPlayer.play("hurt")
		$"..".jahy_hp -= 1

		if body.is_boom_slime: # hit by chiichan super_hit
			$AnimationPlayer.queue("explode")
			$"../Chiichan".can_jump = false

			# unfreeze stuffs
			$"..".unfreeze()


extends Sprite2D


var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")
var rng = RandomNumberGenerator.new()

func play_attack():
	$AnimationPlayer.play("attack")


func play_angry():
	$AnimationPlayer.play("angry")


func push_chiichan():
	$AnimationPlayer.play("attack")
			

func play_explode():
	$AnimationPlayer.play("explode")


func spawn_hit_spark() -> void: # Used by $AnimationPlayer.play 'explode'
	var hitbox = HIT_SPARK.instantiate()
	var offset_x = rng.randi_range(-100, 0)
	var offset_y = rng.randi_range(-100, 100)
	hitbox.position += Vector2(offset_x, offset_y)
	add_child(hitbox)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("RESET")
	elif anim_name == "explode":
		$"../../../ParallaxBackground".freeze()
		$"../../../Chiichan".stop_moving()
		await get_tree().create_timer(1, false).timeout
		$"../../../Chiichan".play_stage1_clear()

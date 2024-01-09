extends RigidBody2D


signal ded


var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")
var rng = RandomNumberGenerator.new()


func spawn_hit_spark() -> void: # Used by $AnimationPlayer.play 'explode'
	var hitbox = HIT_SPARK.instantiate()
	var offset_x = rng.randi_range(-100, 0)
	var offset_y = rng.randi_range(-100, 100)
	hitbox.position += Vector2(offset_x, offset_y)
	add_child(hitbox)


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		# chiichan got pushed away
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-9000, -1900))

	$AnimationPlayer.play("explode")

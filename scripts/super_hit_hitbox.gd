extends Area2D


# preloads
var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")


# Configs
var is_hand = false
var is_sword = false


func _spawn_hit_spark(_node_pos: Node) -> void:
	var hitbox = HIT_SPARK.instantiate()
	hitbox.position = _node_pos.position
	$"..".add_child(hitbox)


func _on_body_entered(body):
	if body.is_in_group("slime"):
		if is_sword:
			body.activate_boom_then(Vector2(2200, 1000))
		elif is_hand:
			body.activate_boom_then(Vector2(2200, -300))
		body.turn_hit_boss_collision()
		_spawn_hit_spark(body)
		$"../CameraWrap/CameraPlayer".play("smol_shake_2")


func _on_timer_timeout():
	queue_free()

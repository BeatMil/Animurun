extends Area2D


# preloads
var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")


func _spawn_hit_spark(_node_pos: Node) -> void:
	var hitbox = HIT_SPARK.instantiate()
	hitbox.position = _node_pos.position
	$"..".add_child(hitbox)


func _on_body_entered(body):
	if body.is_in_group("slime"):
		body.activate_boom_then()
		_spawn_hit_spark(body)
		$"../CameraWrap/CameraPlayer".play("smol_shake_2")


func _on_timer_timeout():
	queue_free()

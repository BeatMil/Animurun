extends Node2D


signal ded


# Preloads
var HIT_SPARK = preload("res://nodes/particles/hit_spark.tscn")

var is_faint = false


func _ready() -> void:
	if is_faint:
		$AnimationPlayer.play("intro_faint")
	else:
		$AnimationPlayer.play("intro")


func _on_area_2d_body_entered(body):
	if body.is_in_group("chiichan"):
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-9000, -1900))


func call_camera_shake():
	$"..".smol_shake()


func _queue_free():
	emit_signal("ded")
	queue_free()


func _turn_off_area2d():
	$Area2D.set_deferred("monitoring", false)


func _spawn_hit_spark() -> void:
	var hit = HIT_SPARK.instantiate()
	var hit2 = HIT_SPARK.instantiate()
	var hit3 = HIT_SPARK.instantiate()
	var hit4 = HIT_SPARK.instantiate()
	hit.position.y -= 400
	hit2.position.y -= 800
	hit3.position.y -= 1000
	hit4.position.y -= 1200
	add_child(hit)
	add_child(hit2)
	add_child(hit3)
	add_child(hit4)

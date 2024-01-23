extends Polygon2D


signal ded

var is_faster = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_faster:
		$AnimationPlayer.play("laser", -1, 1.6, false)
	else:
		$AnimationPlayer.play("laser")


func _signal_ded_and_queue_free():
	emit_signal("ded")
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("chiichan"):
		# chiichan got pushed away
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-9000, -1900))

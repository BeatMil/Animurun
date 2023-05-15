extends Node2D

# Signals
signal successful
signal failed


var can_ora: bool = false
var is_success: bool = false
var ora_count = 0

# Preloads
var ORA_RYTHM = preload("res://nodes/ora_rythm.tscn")


func _ready():
	var spawn_points = $Markers.get_children()
	randomize()
	spawn_points.shuffle()
	for i in range(3):
		var ora_rythm = ORA_RYTHM.instantiate()
		ora_rythm.position = spawn_points[0].position
		call_deferred("add_child", ora_rythm)
		spawn_points.pop_at(0)


func _on_tick_area_entered(_area):
	# only ora can enter
	can_ora = true


func _on_tick_area_exited(_area):
	if is_success:
		can_ora = false # chiichan successfully ora
		is_success = false
	else:
		$AnimationPlayer.play("miss")
		emit_signal("failed")


func _input(event) -> void:
	if event.is_action_pressed("block") or event.is_action_pressed("jump") or event.is_action_pressed("dodge"):
		if can_ora:
			if ora_count <= 0:
				if $Tick.has_overlapping_areas():
					$Tick.get_overlapping_areas()[0].play_anim("hit1")
				ora_count += 1
			elif ora_count == 1:
				if $Tick.has_overlapping_areas():
					$Tick.get_overlapping_areas()[0].play_anim("hit2")
				ora_count += 1
			elif ora_count == 2:
				if $Tick.has_overlapping_areas():
					$Tick.get_overlapping_areas()[0].play_anim("hit3")
				ora_count = 0
				emit_signal("successful")
				$AnimationPlayer.play("success")
			is_success = true
		else:
			$AnimationPlayer.play("miss")
			emit_signal("failed")


func _on_animation_player_animation_finished(anim_name):
	if anim_name in ["miss", "success"]:
		queue_free()

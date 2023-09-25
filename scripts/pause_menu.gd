extends Control


var is_pausable = true
@onready var current_stage = $"../..".get_stage_path()


func _input(event):
	if event.is_action_pressed("ui_cancel") and is_pausable:
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			$"AnimationPlayer".play("pause")
			$"VBoxContainer/HBoxContainer/BoxContainer2/RestartButton".call_deferred("grab_focus")
		else:
			$"AnimationPlayer".play("unpause")


func _on_restart_button_pressed():
	get_tree().change_scene_to_file(current_stage)
	get_tree().paused = false

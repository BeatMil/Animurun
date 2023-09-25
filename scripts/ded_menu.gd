extends Control


@export var pause_menu: Node
@onready var current_stage = $"../..".get_stage_path()


func _on_restart_button_pressed():
	get_tree().change_scene_to_file(current_stage)
	get_tree().paused = false


func show_menu():
	$"AnimationPlayer".play("fade_in")
	$"VBoxContainer/HBoxContainer/BoxContainer2/RestartButton".grab_focus()
	pause_menu.is_pausable = false

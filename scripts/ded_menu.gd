extends Control


@export var pause_menu: Node


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/forest.tscn")


func show_menu():
	$"AnimationPlayer".play("fade_in")
	$"VBoxContainer/HBoxContainer/BoxContainer2/RestartButton".grab_focus()
	pause_menu.is_pausable = false

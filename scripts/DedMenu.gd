extends Control


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Forest.tscn")


func show_menu():
	$"AnimationPlayer".play("fade_in")
	$"VBoxContainer/HBoxContainer/BoxContainer2/RestartButton".grab_focus()

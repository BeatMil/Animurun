extends Control



func _ready():
#	$HBoxContainer/VBoxContainer/Button.grab_focus()
	$OptionMenu.visible = false



func _on_start_button_pressed():
	SceneTransition.change_scene("res://scenes/intro.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_option_button_pressed():
	$OptionMenu.visible = true


func _on_back_button_pressed():
	$OptionMenu.visible = false


func _on_stage_button_pressed():
	SceneTransition.change_scene("res://scenes/ice_mountain.tscn")


func _on_stage_button_2_pressed():
	SceneTransition.change_scene("res://scenes/volcano.tscn")


func _on_stage_button_3_pressed():
	SceneTransition.change_scene("res://scenes/castle.tscn")

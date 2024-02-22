extends Control



func _ready():
#	$HBoxContainer/VBoxContainer/Button.grab_focus()
	pass



func _on_start_button_pressed():
	SceneTransition.change_scene("res://scenes/intro.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_option_button_pressed():
	$OptionMenu.visible = true


func _on_back_button_pressed():
	$OptionMenu.visible = false

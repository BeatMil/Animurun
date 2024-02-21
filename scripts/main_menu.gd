extends Control



func _ready():
	$HBoxContainer/VBoxContainer/Button.grab_focus()


func _on_button_pressed():
	SceneTransition.change_scene("res://scenes/intro.tscn")

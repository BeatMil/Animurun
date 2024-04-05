extends Control



func _ready():
#	$HBoxContainer/VBoxContainer/Button.grab_focus()
	$OptionMenu.visible = false
	Config.checkpoint = -1


func _input(event):
	pass


func _on_start_button_pressed():
	SceneTransition.change_scene("res://scenes/intro.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_option_button_pressed():
	$OptionMenu.visible = true
	$Chiichan.visible = false
	$OptionMenu/AnimationPlayer.play("open")


func _on_back_button_pressed():
	$OptionMenu.visible = false
	$Chiichan.visible = true
	$control_scheme.update_keybinds_display()
	$OptionMenu/AnimationPlayer.play("close")

func _on_stage_button_pressed():
	SceneTransition.change_scene("res://scenes/volcano.tscn")


func _on_stage_button_2_pressed():
	SceneTransition.change_scene("res://scenes/ice_mountain.tscn")


func _on_stage_button_3_pressed():
	SceneTransition.change_scene("res://scenes/castle.tscn")


func _on_area_2d_body_entered(body):
	if body.is_in_group("chiichan"):
		body.push(Vector2(-2000, -10))


func _on_area_2d_left_body_entered(body):
	if body.is_in_group("chiichan"):
		body.push(Vector2(2000, -10))

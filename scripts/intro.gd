extends Node2D


var intro_pics = ["intro_01", "intro_2", "intro_3", "intro_4"]
var current_pic_index = 0


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if current_pic_index >= intro_pics.size() - 1:
			SceneTransition.change_scene("res://scenes/forest.tscn")
			return
		current_pic_index += 1
		$AnimationPlayer.play(intro_pics[current_pic_index])

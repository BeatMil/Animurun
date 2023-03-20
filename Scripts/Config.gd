extends Node


func _ready():
	# 120 fps?
	Engine.physics_ticks_per_second = 120


	# var monitors = DisplayServer.get_screen_count()
	# print("monitors: %s"%[monitors]) 

	# var current_screen = DisplayServer.window_get_current_screen(1)
	# print("current_screen: %s"%[current_screen]) 

	# DisplayServer.window_set_current_screen(0)
	# DisplayServer.window_set_current_screen(1)
	pass


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

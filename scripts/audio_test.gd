extends Control


func _process(_delta):
	AudioServer.set_bus_volume_db(0, $VSlider.value)
	pass


func _on_button_pressed():
	$"AnimationPlayer".stop()
	$"AnimationPlayer".play("test_sound")

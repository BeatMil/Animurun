extends Node2D


var is_jump_key_change: bool = false


func _input(event):
	if event.is_pressed() and is_jump_key_change:
		InputMap.action_erase_events("jump")
		InputMap.action_add_event("jump", event)
		is_jump_key_change = false
		$ColorRect2/Button/JumpKeyLabel.text = event.as_text()
		$ColorRect2/Button.release_focus()


func _on_button_pressed():
	$ColorRect2/Button/JumpKeyLabel.text = "?"
	is_jump_key_change = true

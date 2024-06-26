extends Node2D


var is_jump_key_change: bool = false
var is_dodge_key_change: bool = false
var is_block_key_change: bool = false
var is_left_key_change: bool = false
var is_right_key_change: bool = false


func _input(event):
	if event.is_pressed() and is_jump_key_change:
		InputMap.action_erase_events("jump")
		InputMap.action_add_event("jump", event)
		is_jump_key_change = false
		$ColorRect2/Button/JumpKeyLabel.text = event.as_text()
		$ColorRect2/Button.release_focus()
	elif event.is_pressed() and is_block_key_change:
		InputMap.action_erase_events("block")
		InputMap.action_add_event("block", event)
		is_block_key_change = false
		$ColorRect2/BlockButton/KeyLabel.text = event.as_text()
		$ColorRect2/Button.release_focus()
	elif event.is_pressed() and is_left_key_change:
		InputMap.action_erase_events("move_left")
		InputMap.action_add_event("move_left", event)
		is_left_key_change = false
		$ColorRect2/LeftButton/KeyLabel.text = event.as_text()
		$ColorRect2/LeftButton.release_focus()
	elif event.is_pressed() and is_right_key_change:
		InputMap.action_erase_events("move_right")
		InputMap.action_add_event("move_right", event)
		is_right_key_change = false
		$ColorRect2/RightButton/KeyLabel.text = event.as_text()
		$ColorRect2/RightButton.release_focus()
	elif event.is_pressed() and is_dodge_key_change:
		InputMap.action_erase_events("dodge")
		InputMap.action_add_event("dodge", event)
		is_dodge_key_change = false
		$ColorRect2/DodgeButton/KeyLabel.text = event.as_text()
		$ColorRect2/DodgeButton.release_focus()


func _on_button_pressed():
	$ColorRect2/Button/JumpKeyLabel.text = "?"
	is_jump_key_change = true


func _on_parry_button_pressed():
	$ColorRect2/BlockButton/KeyLabel.text = "?"
	is_block_key_change = true


func _on_left_button_pressed():
	$ColorRect2/LeftButton/KeyLabel.text = "?"
	is_left_key_change = true


func _on_right_button_pressed():
	$ColorRect2/RightButton/KeyLabel.text = "?"
	is_right_key_change = true


func _on_dodge_button_pressed():
	$ColorRect2/DodgeButton/KeyLabel.text = "?"
	is_dodge_key_change = true

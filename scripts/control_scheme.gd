extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	update_keybinds_display()


func update_keybinds_display():
	#move_left
	var move_left_keys = InputMap.action_get_events("move_left")
	$moveLeftKeyLabel.text = move_left_keys[0].as_text()

	#move_right
	var move_right_keys = InputMap.action_get_events("move_right")
	$moveRightKeyLabel.text = move_right_keys[0].as_text()

	#jump
	var jump_keys = InputMap.action_get_events("jump")
	$jumpKeyLabel.text = jump_keys [0].as_text()

	#block
	var block_keys = InputMap.action_get_events("block")
	$blockKeyLabel.text = block_keys [0].as_text()

	#dodge
	var dodge_keys = InputMap.action_get_events("dodge")
	$dodgeKeyLabel.text = dodge_keys [0].as_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

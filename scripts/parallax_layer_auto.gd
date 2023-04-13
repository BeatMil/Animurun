extends ParallaxLayer


@export var SPEED: int = -100


func _process(delta):
	if not $"..".is_freeze:
		motion_offset.x += SPEED * delta

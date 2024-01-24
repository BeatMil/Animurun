extends Area2D


@export var boss: Node


func _on_body_entered(body):
	if body.is_in_group("chiichan"):
		# only chiichan can be detected
		# see? I knew I should if put is_in_group check...
		body.push(Vector2(-4000, 0))

		# tell taiga to do a pose XD
		boss.push_chiichan()

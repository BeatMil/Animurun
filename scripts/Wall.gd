extends Area2D

@export var taiga: Node


func _on_body_entered(body):
	# only chiichan can be detected
	body.push(Vector2(-4000, 0))

	# tell taiga to do a pose XD
	taiga.push_chiichan()

extends Area2D


func _on_body_entered(body):
	# only chiichan can be detected
	body.push(Vector2(-4000, 0))

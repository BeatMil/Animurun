extends Node2D


@export var fire_balls: Array[Sprite2D]


var KISAKIFIREBALL = preload("res://nodes/kisaki_fireball.tscn")


func _ready():
	pass # Replace with function body.


func shoot_fire_ball():
	if fire_balls:
		var fire_ball = fire_balls.pick_random()
		fire_balls.erase(fire_ball)
		if fire_balls.size() > 0:
			spawn_fire_ball(fire_ball.global_position, false)
		else:
			spawn_fire_ball(fire_ball.global_position, true)
		fire_ball.visible = false
	else:
		queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		$"Path2D/AnimationPlayer".play("cycle")


# used in shoot_fire_ball
func spawn_fire_ball(_position: Vector2, _sig: bool):
	var fire_ball = KISAKIFIREBALL.instantiate()
	fire_ball.position = _position
	if _sig:
		fire_ball.connect("ded", $"..".spawner)
	$"..".add_child(fire_ball)



extends Node2D


@export var time_before_queue_free: float = 0
var node_to_follow: Node
var is_following: bool = true


func _ready():
	$Timer.wait_time = time_before_queue_free
	$Timer.start()
	$GPUParticles2D.emitting = true


func _physics_process(_delta):
	if is_following:
		position = node_to_follow.position
	else:
		$"GPUParticles2D".emitting = false


func _on_timer_timeout():
	queue_free()


func _on_stop_following_timer_timeout():
	is_following = false

extends Node2D


func _ready():
	$Timer.wait_time = $GPUParticles2D.lifetime - 0.1
	$Timer.start()


func _on_timer_timeout():
	queue_free()

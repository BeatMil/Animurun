extends Node2D


func _ready():
	$Timer.wait_time = $GPUParticles2D.lifetime
	$Timer.start()
	$GPUParticles2D.emitting = true


func _on_timer_timeout():
	queue_free()

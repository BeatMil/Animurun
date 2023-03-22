extends Node


var SLIME = preload("res://Nodes/Slime.tscn")
# var enemy_spawn_order = [bob1, bob2]


func _ready():
	# spawn_slime()
	spawn_speed_slime()


func spawn_slime():
	var slime = SLIME.instantiate()
	slime.position = $"Markers/EnemySpawnPos".position
	slime.connect("ded", spawn_slime)
	add_child(slime)


func spawn_speed_slime():
	var slime = SLIME.instantiate()
	slime.speed = Vector2(-1500, 0)
	slime.activate_speed()
	slime.position = $"Markers/EnemySpawnPos".position
	slime.connect("ded", spawn_slime)
	add_child(slime)

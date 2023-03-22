extends Node


var SLIME = preload("res://Nodes/Slime.tscn")


func _ready():
	spawn_slime()


func spawn_slime():
	var slime = SLIME.instantiate()
	slime.position = $"Markers/EnemySpawnPos".position
	slime.connect("ded", spawn_slime)
	add_child(slime)

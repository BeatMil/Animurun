extends Node


var SLIME = preload("res://Nodes/Slime.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_slime()


func spawn_slime():
	var slime = SLIME.instantiate()
	slime.position = $"EnemySpawnPos".position
	slime.connect("ded", spawn_slime)
	add_child(slime)

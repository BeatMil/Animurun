extends Node


# Preloads
var SLIME = preload("res://nodes/Slime.tscn")


# Configs
var enemy_spawn_order: Array = [spawn_slime, spawn_slime, spawn_speed_slime]
var order_index: int = 0


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)


func _ready() -> void:
	spawner()


func spawner() -> void:
	enemy_spawn_order[order_index].call()
	order_index += 1
	if order_index >= enemy_order_size:
		order_index = 0


func spawn_slime() -> void:
	var slime = SLIME.instantiate()
	slime.position = $"Markers/EnemySpawnPos".position
	slime.connect("ded", spawner)
	add_child(slime)


func spawn_speed_slime() -> void:
	var slime = SLIME.instantiate()
	slime.activate_speed()
	slime.position = $"Markers/EnemySpawnPos".position
	slime.connect("ded", spawner)
	add_child(slime)

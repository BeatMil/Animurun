extends Node


# Preloads
var SLIME = preload("res://nodes/Slime.tscn")
var ROCKY = preload("res://nodes/Rocky.tscn")
var BOMBY = preload("res://nodes/Bomby.tscn")


# Configs
var enemy_spawn_order: Array = [spawn_slime, spawn_rocky, spawn_bomby]
var order_index: int = 0


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)


func _ready() -> void:
	spawner()


func spawner() -> void:
	enemy_spawn_order[order_index].call()

	## very complicated way of doing by Jero (chatGPT)
	## Reset spawn order cycle
	order_index = (order_index + 1) % enemy_order_size 


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


func spawn_rocky() -> void:
	var rocky = ROCKY.instantiate()
	rocky.position = $"Markers/EnemySpawnPos".position
	rocky.connect("ded", spawner)
	add_child(rocky)


func spawn_bomby() -> void:
	var bomby = BOMBY.instantiate()
	bomby.position = $"Markers/EnemySpawnPos".position
	bomby.connect("ded", spawner)
	add_child(bomby)

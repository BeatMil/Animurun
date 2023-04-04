extends Node


# Preloads
var SLIME = preload("res://nodes/Slime.tscn")
var ROCKY = preload("res://nodes/Rocky.tscn")
var BOMBY = preload("res://nodes/Bomby.tscn")


# Configs
var enemy_spawn_order: Array = [spawn_triple02]
var order_index: int = 0


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)


func _ready() -> void:
	pass
	spawner()


func _process(_delta):
	# debug pp
	$"CanvasLayer/chiichan_velocity".text = str($"Chiichan".velocity)


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


func spawn_speed_bomby() -> void:
	var bomby = BOMBY.instantiate()
	bomby.activate_speed()
	bomby.position = $"Markers/EnemySpawnPos".position
	bomby.connect("ded", spawner)
	add_child(bomby)


func spawn_triple01() -> void:
	var bomby = BOMBY.instantiate()
	bomby.position = $"Markers/EnemySpawnPos".position

	var rocky = ROCKY.instantiate()
	rocky.position = $"Markers/EnemySpawnPos".position

	var slime = SLIME.instantiate()
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos".position

	# add bomby
	bomby.throw_bomb()
	add_child(bomby)
	await get_tree().create_timer(0.3).timeout

	# add rocky
	add_child(rocky)
	await get_tree().create_timer(0.5).timeout

	# add slime
	add_child(slime)


func spawn_triple02() -> void:
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position

	var slime2 = SLIME.instantiate()
	slime2.position = $"Markers/EnemySpawnPos".position

	var slime3 = SLIME.instantiate()
	slime3.connect("ded", spawner)
	slime3.position = $"Markers/EnemySpawnPos".position

	add_child(slime1)
	slime1.throw_slime(Vector2(-2000, -2500))
	await get_tree().create_timer(0.3).timeout

	add_child(slime2)
	slime2.throw_slime(Vector2(-2000, -2000))
	await get_tree().create_timer(0.3).timeout

	add_child(slime3)
	slime3.throw_slime(Vector2(-1900, -1900))


func _on_spawn_timer_timeout():
	spawner()

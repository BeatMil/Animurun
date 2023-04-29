extends Node


# Preloads
var SLIME = preload("res://nodes/slime.tscn")
var ROCKY = preload("res://nodes/rocky.tscn")
var BOMBY = preload("res://nodes/bomby.tscn")
var SPIKE = preload("res://nodes/spike.tscn")


# Configs
# var enemy_spawn_order: Array = [spawn_triple01, spawn_triple02, spawn_triple03, spawn_triple04, spawn_triple05, spawn_five_bombs, spawn_five_ground_bombs, spawn_2rock_1speed, spawn_2rock_1slime, spawn_slime_rocks, spawn_2bomb_rock_slime]
# var enemy_spawn_order: Array = [spawn_boom_slime_sword]
# var enemy_spawn_order: Array = [spawn_boom_slime_hand]
var enemy_spawn_order: Array = [spawn_slime, spawn_bomby]
# var enemy_spawn_order: Array = [spawn_spike]
var order_index: int = 0 # spawner helper
var is_random_spawn = false
var rng = RandomNumberGenerator.new()
var tutorial_phase_helper = 1


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)


func _ready() -> void:
	pass
	spawner()


func _process(_delta):
	# debug pp
	$"CanvasLayer/chiichan_velocity".text = str($"Chiichan".velocity)
	$"CanvasLayer/chiichan_state".text = str($"Chiichan".States.keys()[$"Chiichan".state])


func spawner() -> void:
	if tutorial_phase_helper >= 2: # chiichan hits 2 slimes to end tutorial phase
		spawn_phase_one()

	if not enemy_spawn_order.size():
		return

	if is_random_spawn:
		order_index = rng.randi_range(0, enemy_order_size - 1)

	enemy_spawn_order[order_index].call()

	## very complicated way of doing by Jero (chatGPT)
	## Reset spawn order cycle
	order_index = (order_index + 1) % enemy_order_size 


func spawn_tutorial_phase() -> void:
	enemy_spawn_order = [spawn_slime, spawn_bomby]


func spawn_phase_one() -> void:
	enemy_spawn_order = [spawn_parry_dodge_chain, spawn_two_slime]
	enemy_order_size = enemy_spawn_order.size()


###
### Enemy Patterns
### Starts
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


func spawn_two_slime() -> void: # learn to chain parry
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position

	var slime3 = SLIME.instantiate()
	slime3.connect("ded", spawner)
	slime3.position = $"Markers/EnemySpawnPos".position

	add_child(slime1)
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime3)


func spawn_parry_dodge_chain() -> void: # learn to chain parry and dodge
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position

	var bomby = BOMBY.instantiate()
	bomby.position = $"Markers/EnemySpawnPos".position

	var slime3 = SLIME.instantiate()
	slime3.connect("ded", spawner)
	slime3.position = $"Markers/EnemySpawnPos".position

	add_child(slime1)
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime3)
	await get_tree().create_timer(0.3, false).timeout

	add_child(bomby)


func spawn_triple_slime() -> void:
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position

	var slime2 = SLIME.instantiate()
	slime2.position = $"Markers/EnemySpawnPos".position

	var slime3 = SLIME.instantiate()
	slime3.connect("ded", spawner)
	slime3.position = $"Markers/EnemySpawnPos".position

	add_child(slime1)
	slime1.throw_slime(Vector2(-2000, -2000))
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime2)
	slime2.throw_slime(Vector2(-2000, -2000))
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime3)
	slime3.throw_slime(Vector2(-2000, -2000))


func spawn_spike() -> void:
	var spike = SPIKE.instantiate()
	spike.position = $"Markers/SpikeSpawnPos".position
	spike.connect("ded", spawner)
	add_child(spike)


func spawn_boom_slime_hand() -> void:
	var slime = SLIME.instantiate()
	slime.is_boom_slime = true
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos2".position

	add_child(slime)
	slime.throw_slime(Vector2(-3000, -1200))

###
### Enemy Patterns
### Ends


func smol_shake() -> void:
	$"%CameraPlayer".stop()
	$"%CameraPlayer".play("smol_shake")


func _on_spawn_timer_timeout():
	spawner()

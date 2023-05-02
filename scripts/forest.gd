extends Node


enum Phases {
	TUTORIAL,
	ONE,
	ONE_TO_TWO,
	TWO,
	TWO_TO_THREE,
	THREE,
	}


# Preloads
var SLIME = preload("res://nodes/slime.tscn")
var ROCKY = preload("res://nodes/rocky.tscn")
var BOMBY = preload("res://nodes/bomby.tscn")
var SPIKE = preload("res://nodes/spike.tscn")
var TANK = preload("res://nodes/tank_bomb.tscn")


# Configs
var enemy_spawn_order: Array = []
var order_index: int = 0 # spawner helper
var is_random_spawn = false
var rng = RandomNumberGenerator.new()
var taiga_hp = 0
var phase_helper = 2 # choose phase then minus 1 
var phase_transition_helper = false


# Phases
var tutorial_phase_enemy_order: Array = [spawn_slime, spawn_bomby]
var phase_one_enemy_order: Array = [spawn_parry_dodge_chain, spawn_two_slime, spawn_spike]

# var phase_two_enemy_order: Array = [spawn_tank, spawn_tank_left_side, spawn_tank_left_side_spike, spawn_triple_slime, spawn_triple_slime_fake]
var phase_two_enemy_order: Array = [spawn_spike_storm]


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
	if taiga_hp <= 0:
		phase_helper += 1
		if phase_helper == Phases.TUTORIAL:
			spawn_tutorial_phase()
		elif phase_helper == Phases.ONE:
			spawn_phase_one()
		elif phase_helper == Phases.ONE_TO_TWO:
			spawn_phase_two_transition()
		elif phase_helper == Phases.TWO:
			spawn_phase_two()

	if not enemy_spawn_order.size(): # don't spawn when array is empty
		return

	if is_random_spawn:
		order_index = rng.randi_range(0, enemy_order_size - 1)

	enemy_spawn_order[order_index].call()

	## very complicated way of doing by Jero (chatGPT)
	## Reset spawn order cycle
	order_index = (order_index + 1) % enemy_order_size 


func phase_transition_checker():
	if phase_helper == Phases.TWO:
		phase_transition_helper = true
	elif phase_helper == Phases.THREE:
		phase_transition_helper = true


func spawn_tutorial_phase() -> void:
	taiga_hp = 2
	enemy_spawn_order = tutorial_phase_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_one() -> void:
	taiga_hp = 6
	order_index = 0
	enemy_spawn_order = phase_one_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_two_transition() -> void:
	taiga_hp = 1
	order_index = 0
	enemy_spawn_order = [spawn_boom_slime_hand]
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_two() -> void:
	order_index = 0
	enemy_spawn_order = phase_two_enemy_order
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


func spawn_tank() -> void:
	var tank = TANK.instantiate()
	tank.position = $"Markers/TankSpawnPos1".position
	tank.connect("ded", spawner)
	$"Taiga".play("pre_attack")
	add_child(tank)


func spawn_tank_left_side() -> void:
	var tank1 = TANK.instantiate()
	tank1.position = $"Markers/TankSpawnPos1".position

	var tank2 = TANK.instantiate()
	tank2.position = $"Markers/TankSpawnPos2".position
	tank2.connect("ded", spawner)

	$"Taiga".play("pre_attack")
	add_child(tank1)
	await get_tree().create_timer(0.3, false).timeout

	$"Taiga".play("pre_attack")
	add_child(tank2)


func spawn_tank_left_side_spike() -> void:
	var tank1 = TANK.instantiate()
	tank1.position = $"Markers/TankSpawnPos1".position

	var tank2 = TANK.instantiate()
	tank2.position = $"Markers/TankSpawnPos2".position

	var spike = SPIKE.instantiate()
	spike.position = $"Markers/SpikeSpawnPos".position

	var slime = SLIME.instantiate()
	slime.position = $"Markers/EnemySpawnPos".position
	slime.connect("ded", spawner)

	$"Taiga".play("pre_attack")
	add_child(tank1)
	await get_tree().create_timer(0.3, false).timeout

	$"Taiga".play("pre_attack")
	add_child(tank2)
	await get_tree().create_timer(0.3, false).timeout

	add_child(spike)
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime)


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


func spawn_triple_slime_fake() -> void:
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position

	var tank = TANK.instantiate()
	tank.position = $"Markers/TankSpawnPos3".position

	var slime3 = SLIME.instantiate()
	slime3.connect("ded", spawner)
	slime3.position = $"Markers/EnemySpawnPos".position

	add_child(slime1)
	slime1.throw_slime(Vector2(-2000, -2000))
	await get_tree().create_timer(0.3, false).timeout

	add_child(tank)
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime3)
	slime3.throw_slime(Vector2(-2000, -2000))


func spawn_spike() -> void:
	var spike = SPIKE.instantiate()
	spike.position = $"Markers/SpikeSpawnPos".position
	spike.connect("ded", spawner)
	add_child(spike)


func spawn_spike_follow() -> void:
	var spike = SPIKE.instantiate()
	spike.position = $"Chiichan".position
	# spike.position = $"Markers/SpikeSpawnPos".position
	# spike.position.x = $"Chiichan".position.x
	# spike.position.y = $"Markers/SpikeSpawnPos".position.y
	spike.connect("ded", spawner)
	add_child(spike)


func spawn_spike_storm() -> void:
	var spike1 = SPIKE.instantiate()

	var spike2 = SPIKE.instantiate()

	var spike3 = SPIKE.instantiate()

	var spike4 = SPIKE.instantiate()

	var spike5 = SPIKE.instantiate()
	spike5.connect("ded", spawner)

	spike1.position = $"Chiichan".position
	$"Taiga".play("pre_attack")
	add_child(spike1)
	await get_tree().create_timer(0.3, false).timeout

	$"Taiga".play("pre_attack")
	spike2.position = $"Chiichan".position
	add_child(spike2)
	await get_tree().create_timer(0.3, false).timeout

	$"Taiga".play("pre_attack")
	spike3.position = $"Chiichan".position
	add_child(spike3)
	await get_tree().create_timer(0.3, false).timeout

	$"Taiga".play("pre_attack")
	spike4.position = $"Chiichan".position
	add_child(spike4)
	await get_tree().create_timer(0.3, false).timeout

	$"Taiga".play("pre_attack")
	spike5.position = $"Chiichan".position
	add_child(spike5)


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

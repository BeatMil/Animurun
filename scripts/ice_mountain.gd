extends Node


enum Phases {
	ONE,
	ONE_TO_TWO,
	TWO,
	TWO_TO_THREE,
	THREE,
	END,
	}


# Preloads
var AFURE_GAZAR = preload("res://nodes/afure_gazar.tscn")
var WAVE = preload("res://nodes/jahy_attacks/wave.tscn")
var MAGIC_CIRCLE = preload("res://nodes/jahy_attacks/magic_circle.tscn")


# Configs
var enemy_spawn_order: Array = []
var phase_helper = 3 # Use Phases enum
var order_index: int = 0 # spawner helper
var jahy_hp = 0
var is_random_spawn = false
var rng = RandomNumberGenerator.new()


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)
@onready var jahy = $Boss


# Phases
var phase_one_enemy_order: Array = [spawn_afure_gazar, spawn_wave, spawn_magic_circle]
var phase_two_enemy_order: Array = []
var phase_three_enemy_order: Array = []


func _ready() -> void:
	phase_helper = $/root/Config.checkpoint
	spawner()
	print("hp: ", jahy_hp)


"""
At the end of attack pattern, a mob will signal spanwer to spawn next 
attack pattern
"""
func spawner() -> void:
	print("hp: ", jahy_hp)
	print(Phases.find_key(phase_helper))
	if jahy_hp <= 0:
		phase_helper += 1
		if phase_helper == Phases.ONE:
			spawn_phase_one()
		elif phase_helper == Phases.ONE_TO_TWO:
			jahy.play_angry()
			print("====ME ANGY====")
			return
		elif phase_helper == Phases.TWO:
			spawn_phase_two()
		elif phase_helper == Phases.TWO_TO_THREE:
			jahy.play_angry()
			print("====ME ANGY2====")
			return
		elif phase_helper == Phases.THREE:
			spawn_phase_three()
		elif phase_helper == Phases.END:
			jahy.play_explode()
			return

	if not enemy_spawn_order.size(): # don't spawn when array is empty
		return

	if is_random_spawn:
		order_index = rng.randi_range(0, enemy_order_size - 1)

	enemy_spawn_order[order_index].call()

	## very complicated way of doing by Jero (chatGPT)
	## Reset spawn order cycle
	order_index = (order_index + 1) % enemy_order_size 


func unfreeze() -> void:
	$"ParallaxBackground".unfreeze()
	$"BackgroundDim".unfreeze()
	$"CameraWrap/CameraPlayer".play_backwards("super_hit_zoom")


func save_checkpoint() -> void:
	$"/root/Config".checkpoint  = phase_helper - 1


func get_stage_path() -> String:
	return "res://scenes/ice_mountain.tscn"


func spawn_phase_one() -> void:
	jahy_hp = 6
	order_index = 0
	enemy_spawn_order = phase_one_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_two() -> void:
	jahy_hp = 6
	order_index = 0
	enemy_spawn_order = phase_two_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_three() -> void:
	jahy_hp = 1
	order_index = 0
	enemy_spawn_order = phase_three_enemy_order
	enemy_order_size = enemy_spawn_order.size()


###
### Enemy Patterns
### Starts
func spawn_afure_gazar() -> void:
	var afure_gazar = AFURE_GAZAR.instantiate()
	afure_gazar.position = $"Markers/AfureGazarSpawnPos".position
	afure_gazar.set_z_index(-6)
	afure_gazar.connect("ded", spawner)

	jahy.play_attack2()
	add_child(afure_gazar)


func spawn_wave() -> void:
	var wave = WAVE.instantiate()
	wave.position = $"Markers/WaveSpawnPos".position
	wave.connect("ded", spawner)

	jahy.play_attack3()
	add_child(wave)


func spawn_magic_circle() -> void:
	var magic = MAGIC_CIRCLE.instantiate()
	magic.position = $"Markers/MagicCircleSpawnPos".position
	magic.connect("ded", spawner)

	jahy.play_attack3()
	add_child(magic)


func smol_shake() -> void:
	$"%CameraPlayer".stop()
	$"%CameraPlayer".play("smol_shake")


func smol_shake_offset() -> void:
	$"%CameraPlayer2".stop()
	$"%CameraPlayer2".play("smol_shake_3")

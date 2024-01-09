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
var METEO = preload("res://nodes/final_boss/meteo.tscn")
var SLIME = preload("res://nodes/slime.tscn")


# Configs
var enemy_spawn_order: Array = []
var phase_helper = 0 # Use Phases enum
var order_index: int = 0 # spawner helper
var kaisouko_hp = 0
var is_random_spawn = false
var rng = RandomNumberGenerator.new()


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)
@onready var kaisouko = %FinalBoss


# Phases
var phase_one_enemy_order: Array = [spawn_meteo]
var phase_two_enemy_order: Array = []
var phase_three_enemy_order: Array = []


func _ready() -> void:
	# wait for scene transition to end
	await get_tree().create_timer(1, false).timeout

	phase_helper = Config.checkpoint
	spawner()


"""
At the end of attack pattern, a mob will signal spanwer to spawn next 
attack pattern
"""
func spawner() -> void:
	print("hp: ", kaisouko_hp)
	print(Phases.find_key(phase_helper))
	if kaisouko_hp <= 0:
		phase_helper += 1
		if phase_helper == Phases.ONE:
			spawn_phase_one()
		elif phase_helper == Phases.ONE_TO_TWO:
			kaisouko.play_angry()
			print("====ME ANGY====")
			return
		elif phase_helper == Phases.TWO:
			spawn_phase_two()
		elif phase_helper == Phases.TWO_TO_THREE:
			kaisouko.play_angry()
			print("====ME ANGY2====")
			return
		elif phase_helper == Phases.THREE:
			spawn_phase_three()
		elif phase_helper == Phases.END:
			kaisouko.play_explode()
			return
	else:
		kaisouko_hp -= 1

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
	return "res://scenes/castle.tscn"


func spawn_phase_one() -> void:
	kaisouko_hp = 3
	order_index = 0
	enemy_spawn_order = phase_one_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_two() -> void:
	kaisouko_hp = 3
	order_index = 0
	enemy_spawn_order = phase_two_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_three() -> void:
	kaisouko_hp = 1
	order_index = 0
	enemy_spawn_order = phase_three_enemy_order
	enemy_order_size = enemy_spawn_order.size()


###
### Enemy Patterns
### Starts
func spawn_meteo() -> void:
	var meteo = METEO.instantiate()
	meteo.position = $"Markers/MeteoSpawnPos1".position
	meteo.connect("ded", spawner)

	kaisouko.play_attack()
	add_child(meteo)


func spawn_boom_slime_hand() -> void:
	var slime = SLIME.instantiate()
	slime.is_boom_slime = true
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos2".position

	kaisouko.play_attack()
	await get_tree().create_timer(0.2, false).timeout

	add_child(slime)
	slime.throw_slime(Vector2(-3000, -1200))


func smol_shake() -> void:
	$"%CameraPlayer".stop()
	$"%CameraPlayer".play("smol_shake")


func smol_shake_offset() -> void:
	$"%CameraPlayer2".stop()
	$"%CameraPlayer2".play("smol_shake_3")

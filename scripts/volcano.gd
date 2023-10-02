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
var SLIME_JUMP = preload("res://nodes/slime_jump.tscn")
var SLIME = preload("res://nodes/slime.tscn")
var WHEEL = preload("res://nodes/kisaki_fireball_wheel.tscn")
var CAPSULE = preload("res://nodes/capsule.tscn")


# Configs
var enemy_spawn_order: Array = []
var phase_helper = -1 # Use Phases enum
var order_index: int = 0 # spawner helper
var kisaki_hp = 0
var is_random_spawn = false
var rng = RandomNumberGenerator.new()


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)


# Phases
# var phase_one_enemy_order: Array = [spawn_wheel, spawn_jump_slime]
var phase_one_enemy_order: Array = [spawn_capsule]


func _ready() -> void:
	# phase_helper = $/root/Config.checkpoint
	spawner()


"""
At the end of attack pattern, a mob will signal spanwer to spawn next 
attack pattern
"""
func spawner() -> void:
	if kisaki_hp <= 0:
		phase_helper += 1
		if phase_helper == Phases.ONE:
			spawn_phase_one()

	if not enemy_spawn_order.size(): # don't spawn when array is empty
		return

	if is_random_spawn:
		order_index = rng.randi_range(0, enemy_order_size - 1)

	enemy_spawn_order[order_index].call()

	## very complicated way of doing by Jero (chatGPT)
	## Reset spawn order cycle
	order_index = (order_index + 1) % enemy_order_size 
	# print("▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦")
	# print(phase_helper)
	# print(Phases.ONE)
	# print("▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦")



func save_checkpoint() -> void:
	$"/root/Config".checkpoint  = phase_helper - 1


func get_stage_path() -> String:
	return "res://scenes/volcano.tscn"


func spawn_phase_one() -> void:
	kisaki_hp = 6
	order_index = 0
	enemy_spawn_order = phase_one_enemy_order
	enemy_order_size = enemy_spawn_order.size()


###
### Enemy Patterns
### Starts
func spawn_jump_slime() -> void:
	var jump_slime = SLIME_JUMP.instantiate()
	jump_slime.position = $"Markers/EnemySpawnPos".position

	var slime = SLIME.instantiate()
	slime.position = $"Markers/EnemySpawnPos".position
	slime.connect("ded", spawner)


	$Kisaki.play_attack()
	add_child(jump_slime)
	await get_tree().create_timer(2, false).timeout

	$Kisaki.play_attack()
	add_child(slime)
	slime.throw_slime(Vector2(-2000, -2000))


func spawn_wheel() -> void:
	var wheel = WHEEL.instantiate()
	wheel.position = $"Markers/WheelSpawnPos2".position

	$Kisaki.play_attack()
	add_child(wheel)


func spawn_capsule() -> void:
	var capsule = CAPSULE.instantiate()
	capsule.position = $"Markers/CapsuleSpawnPos".position
	capsule.connect("ded", spawner)

	$Kisaki.play_attack()
	add_child(capsule)


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
var phase_helper = 3 # Use Phases enum
var order_index: int = 0 # spawner helper
var kisaki_hp = 0
var is_random_spawn = false
var rng = RandomNumberGenerator.new()



# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)
@onready var kisaki = $Boss


# Phases
var phase_one_enemy_order: Array = [spawn_wheel, spawn_jump_slime, spawn_capsule]
var phase_two_enemy_order: Array = [spawn_wheel_faster, spawn_capsule_faster, spawn_jump_slime]
var phase_three_enemy_order: Array = [spawn_boom_slime_hand]


func _ready() -> void:
	# phase_helper = $/root/Config.checkpoint
	# spawner()
	print("hp: ", kisaki_hp)


"""
At the end of attack pattern, a mob will signal spanwer to spawn next 
attack pattern
"""
func spawner() -> void:
	print("hp: ", kisaki_hp)
	print(Phases.find_key(phase_helper))
	if kisaki_hp <= 0:
		phase_helper += 1
		if phase_helper == Phases.ONE:
			spawn_phase_one()
		elif phase_helper == Phases.ONE_TO_TWO:
			kisaki.play_angry()
			print("====ME ANGY====")
			return
		elif phase_helper == Phases.TWO:
			spawn_phase_two()
		elif phase_helper == Phases.TWO_TO_THREE:
			kisaki.play_angry()
			print("====ME ANGY2====")
			return
		elif phase_helper == Phases.THREE:
			spawn_phase_three()
		elif phase_helper == Phases.END:
			kisaki.play_explode()
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
	return "res://scenes/volcano.tscn"


func spawn_phase_one() -> void:
	kisaki_hp = 6
	order_index = 0
	enemy_spawn_order = phase_one_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_two() -> void:
	kisaki_hp = 6
	order_index = 0
	enemy_spawn_order = phase_two_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_three() -> void:
	kisaki_hp = 1
	order_index = 0
	enemy_spawn_order = phase_three_enemy_order
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


	kisaki.play_attack()
	add_child(jump_slime)
	await get_tree().create_timer(2, false).timeout

	kisaki.play_attack()
	add_child(slime)
	slime.throw_slime(Vector2(-2000, -2000))


func spawn_wheel() -> void:
	var wheel = WHEEL.instantiate()
	wheel.position = $"Markers/WheelSpawnPos2".position

	kisaki.play_attack()
	add_child(wheel)


func spawn_capsule() -> void:
	var capsule = CAPSULE.instantiate()
	capsule.position = $"Markers/CapsuleSpawnPos".position
	capsule.connect("ded", spawner)

	kisaki.play_attack()
	add_child(capsule)


func spawn_capsule_faster() -> void:
	var capsule = CAPSULE.instantiate()
	capsule.position = $"Markers/CapsuleSpawnPos".position
	capsule.connect("ded", spawner)
	capsule.is_faster = true

	kisaki.play_attack()
	add_child(capsule)


func spawn_wheel_faster() -> void:
	var wheel = WHEEL.instantiate()
	wheel.position = $"Markers/WheelSpawnPos2".position
	wheel.is_faster = true

	kisaki.play_attack()
	add_child(wheel)


func spawn_boom_slime_hand() -> void:
	var slime = SLIME.instantiate()
	slime.is_boom_slime = true
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos2".position

	kisaki.play_attack()
	await get_tree().create_timer(0.2, false).timeout

	add_child(slime)
	slime.throw_slime(Vector2(-3000, -1200))

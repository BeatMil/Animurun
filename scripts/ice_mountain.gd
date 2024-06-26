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
var WAVE_DODGABLE = preload("res://nodes/jahy_attacks/wave_dodgable.tscn")
var MAGIC_CIRCLE = preload("res://nodes/jahy_attacks/magic_circle.tscn")
var SLIME = preload("res://nodes/slime.tscn")



# Configs
var enemy_spawn_order: Array = []
var phase_helper = 0 # Use Phases enum
var order_index: int = 0 # spawner helper
var jahy_hp = 0
var is_random_spawn = false
var rng = RandomNumberGenerator.new()


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)
@onready var jahy = $Boss


# Phases
var phase_one_enemy_order: Array = [spawn_waves, spawn_afure_gazar, spawn_magic_circle]
var phase_two_enemy_order: Array = [spawn_waves_faster, spawn_magic_circle_faster, spawn_afure_gazar_faint_random]
var phase_three_enemy_order: Array = [spawn_boom_slime_hand]


func _ready() -> void:
	# wait for scene transition to end
	await get_tree().create_timer(1, false).timeout

	phase_helper = Config.checkpoint
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
	else:
		jahy_hp -= 1

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
	jahy_hp = 5
	order_index = 0
	enemy_spawn_order = phase_one_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_two() -> void:
	jahy_hp = 5
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


func spawn_afure_gazar_faint_random() -> void:
	var afure_gazar = AFURE_GAZAR.instantiate()
	afure_gazar.position = $"Markers/AfureGazarSpawnPos".position
	afure_gazar.set_z_index(-6)
	afure_gazar.connect("ded", spawner)

	if rng.randi_range(0, 1) >= 1:
		afure_gazar.is_faint = true
	else:
		afure_gazar.is_faint = false

	jahy.play_attack2()
	add_child(afure_gazar)


func spawn_wave() -> void:
	var wave = WAVE.instantiate()
	wave.position = $"Markers/WaveSpawnPos".position
	wave.connect("ded", spawner)

	jahy.play_attack3()
	add_child(wave)


func spawn_wave_dodgable() -> void:
	var wave = WAVE_DODGABLE.instantiate()
	wave.position = $"Markers/WaveSpawnPos".position
	wave.connect("ded", spawner)

	jahy.play_attack3()
	add_child(wave)


func spawn_waves() -> void:
	var wave = WAVE.instantiate()
	var wave2 = WAVE.instantiate()
	var wave3 = WAVE.instantiate()
	var wave4 = WAVE.instantiate()
	wave.position = $"Markers/WaveSpawnPos".position
	wave2.position = $"Markers/WaveSpawnPos".position
	wave3.position = $"Markers/WaveSpawnPos".position
	wave4.position = $"Markers/WaveSpawnPos".position

	var wave_d = WAVE_DODGABLE.instantiate()
	var wave_d2 = WAVE_DODGABLE.instantiate()
	var wave_d3 = WAVE_DODGABLE.instantiate()
	var wave_d4 = WAVE_DODGABLE.instantiate()
	wave_d.position = $"Markers/WaveSpawnPos".position
	wave_d2.position = $"Markers/WaveSpawnPos".position
	wave_d3.position = $"Markers/WaveSpawnPos".position
	wave_d4.position = $"Markers/WaveSpawnPos".position

	var waves = [wave, wave2, wave3, wave4, wave_d, wave_d2, wave_d3, wave_d4]
	waves.shuffle()

	for i in range(4):
		jahy.play_attack3()
		if i == 3:
			waves[i].connect("ded", spawner)
		add_child(waves[i])
		await get_tree().create_timer(0.6, false).timeout


func spawn_waves_faster() -> void:
	var wave = WAVE.instantiate()
	var wave2 = WAVE.instantiate()
	var wave3 = WAVE.instantiate()
	var wave4 = WAVE.instantiate()
	wave.position = $"Markers/WaveSpawnPos".position
	wave2.position = $"Markers/WaveSpawnPos".position
	wave3.position = $"Markers/WaveSpawnPos".position
	wave4.position = $"Markers/WaveSpawnPos".position

	var wave_d = WAVE_DODGABLE.instantiate()
	var wave_d2 = WAVE_DODGABLE.instantiate()
	var wave_d3 = WAVE_DODGABLE.instantiate()
	var wave_d4 = WAVE_DODGABLE.instantiate()
	wave_d.position = $"Markers/WaveSpawnPos".position
	wave_d2.position = $"Markers/WaveSpawnPos".position
	wave_d3.position = $"Markers/WaveSpawnPos".position
	wave_d4.position = $"Markers/WaveSpawnPos".position

	var waves = [wave, wave2, wave3, wave4, wave_d, wave_d2, wave_d3, wave_d4]
	waves.shuffle()

	for i in range(4):
		jahy.play_attack3()
		if i == 3:
			waves[i].connect("ded", spawner)
		add_child(waves[i])
		await get_tree().create_timer(0.5, false).timeout


func spawn_magic_circle() -> void:
	var magic = MAGIC_CIRCLE.instantiate()
	magic.position = $"Markers/MagicCircleSpawnPos".position
	magic.connect("ded", spawner)

	jahy.play_attack3()
	add_child(magic)


func spawn_magic_circle_faster() -> void:
	var magic = MAGIC_CIRCLE.instantiate()
	magic.position = $"Markers/MagicCircleSpawnPos".position
	magic.connect("ded", spawner)
	magic.is_faster = true

	jahy.play_attack3()
	add_child(magic)


func spawn_boom_slime_hand() -> void:
	var slime = SLIME.instantiate()
	slime.is_boom_slime = true
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos2".position

	jahy.play_attack()
	await get_tree().create_timer(0.2, false).timeout

	add_child(slime)
	slime.throw_slime(Vector2(-3000, -1200))


func smol_shake() -> void:
	$"%CameraPlayer".stop()
	$"%CameraPlayer".play("smol_shake")


func smol_shake_offset() -> void:
	$"%CameraPlayer2".stop()
	$"%CameraPlayer2".play("smol_shake_3")


func go_to_next_stage():
	SceneTransition.change_scene("res://scenes/castle.tscn")
	Config.checkpoint = -1

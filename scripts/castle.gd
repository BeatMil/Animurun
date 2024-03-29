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
var TELEGRAPH = preload("res://nodes/telegraph_meteo.tscn")
var LASER = preload("res://nodes/final_boss/laser.tscn")
var SLIME = preload("res://nodes/slime.tscn")
var BOMBY = preload("res://nodes/bomby.tscn")


# Configs
var enemy_spawn_order: Array = []
var phase_helper = 0 # Use Phases enum
var order_index: int = 0 # spawner helper
var kaisouko_hp = 0
var is_random_spawn = false
var rng = RandomNumberGenerator.new()


# Reference
@onready var enemy_order_size: int = len(enemy_spawn_order)
@onready var kaisouko = %Boss


# Phases
var phase_one_enemy_order: Array = [spawn_laser, spawn_strong_wind, spawn_meteo]
var phase_two_enemy_order: Array = [spawn_laser_faster, spawn_strong_wind_faster, spawn_meteo_faster]
var phase_three_enemy_order: Array = [spawn_ora_ora]


func _ready() -> void:
	# wait for scene transition to end
	await get_tree().create_timer(1, false).timeout

	phase_helper = Config.checkpoint
	# phase_helper = 3
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
	kaisouko_hp = 4
	order_index = 0
	enemy_spawn_order = phase_one_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_two() -> void:
	kaisouko_hp = 7
	order_index = 0
	enemy_spawn_order = phase_two_enemy_order
	enemy_order_size = enemy_spawn_order.size()


func spawn_phase_three() -> void:
	kaisouko_hp = 100
	order_index = 0
	enemy_spawn_order = phase_three_enemy_order
	enemy_order_size = enemy_spawn_order.size()


###
### Enemy Patterns
### Starts
func spawn_meteo() -> void:
	var spawn_rate = 0.5 # interval between each meteo (second)
	var spawn_pos = [
		$"Markers/MeteoSpawnPos1".position,
		$"Markers/MeteoSpawnPos2".position,
		$"Markers/MeteoSpawnPos3".position,
		$"Markers/MeteoSpawnPos4".position,
		]
	spawn_pos.shuffle()

	var meteo = METEO.instantiate()
	meteo.position = spawn_pos[0]
	var telegraph = TELEGRAPH.instantiate()
	telegraph.position = spawn_pos.pop_front()

	var meteo2 = METEO.instantiate()
	meteo2.position = spawn_pos[0]
	var telegraph2 = TELEGRAPH.instantiate()
	telegraph2.position = spawn_pos.pop_front()

	var meteo3 = METEO.instantiate()
	meteo3.position = spawn_pos[0]
	var telegraph3 = TELEGRAPH.instantiate()
	telegraph3.position = spawn_pos.pop_front()

	var meteo4 = METEO.instantiate()
	meteo4.position = spawn_pos[0]
	var telegraph4 = TELEGRAPH.instantiate()
	telegraph4.position = spawn_pos.pop_front()
	meteo4.connect("ded", spawner)


	kaisouko.play_attack()

	# first meteo
	add_child(telegraph)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo)
	await get_tree().create_timer(spawn_rate, false).timeout

	# second meteo
	add_child(telegraph2)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo2)
	await get_tree().create_timer(spawn_rate, false).timeout

	# third meteo
	add_child(telegraph3)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo3)
	await get_tree().create_timer(spawn_rate, false).timeout

	# fourth meteo
	add_child(telegraph4)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo4)
	await get_tree().create_timer(spawn_rate, false).timeout


func spawn_meteo_faster() -> void:
	var spawn_rate = 0.2 # interval between each meteo (second)
	var spawn_pos = [
		$"Markers/MeteoSpawnPos1".position,
		$"Markers/MeteoSpawnPos2".position,
		$"Markers/MeteoSpawnPos3".position,
		$"Markers/MeteoSpawnPos4".position,
		]
	spawn_pos.shuffle()

	var meteo = METEO.instantiate()
	meteo.position = spawn_pos[0]
	var telegraph = TELEGRAPH.instantiate()
	telegraph.position = spawn_pos.pop_front()

	var meteo2 = METEO.instantiate()
	meteo2.position = spawn_pos[0]
	var telegraph2 = TELEGRAPH.instantiate()
	telegraph2.position = spawn_pos.pop_front()

	var meteo3 = METEO.instantiate()
	meteo3.position = spawn_pos[0]
	var telegraph3 = TELEGRAPH.instantiate()
	telegraph3.position = spawn_pos.pop_front()

	var meteo4 = METEO.instantiate()
	meteo4.position = spawn_pos[0]
	var telegraph4 = TELEGRAPH.instantiate()
	telegraph4.position = spawn_pos.pop_front()
	meteo4.connect("ded", spawner)


	kaisouko.play_attack()

	# first meteo
	add_child(telegraph)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo)
	await get_tree().create_timer(spawn_rate, false).timeout

	# second meteo
	add_child(telegraph2)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo2)
	await get_tree().create_timer(spawn_rate, false).timeout

	# third meteo
	add_child(telegraph3)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo3)
	await get_tree().create_timer(spawn_rate, false).timeout

	# fourth meteo
	add_child(telegraph4)
	await get_tree().create_timer(spawn_rate, false).timeout
	add_child(meteo4)
	await get_tree().create_timer(spawn_rate, false).timeout


func spawn_laser() -> void:
	var laser = LASER.instantiate()
	laser.position = $"Markers/LaserSpawnPos".position
	laser.connect("ded", spawner)

	kaisouko.play_attack()

	add_child(laser)


func spawn_laser_faster() -> void:
	var laser = LASER.instantiate()
	laser.is_faster = true
	laser.position = $"Markers/LaserSpawnPos".position
	laser.connect("ded", spawner)

	kaisouko.play_attack()

	add_child(laser)


func spawn_strong_wind() -> void:
	# Set up
	var enemies = [spawn_slime, spawn_slime,spawn_slime,spawn_bomby,spawn_bomby,spawn_bomby]
	enemies.shuffle()
	kaisouko.play_attack()
	$AnimationPlayer.play("strong_wind")
	%ParallaxClouds.SPEED = -1000
	$Chiichan.is_strong_wind = true

	await get_tree().create_timer(1, false).timeout

	# Obstacles
	for i in range(randi_range(3, 5)):
		enemies[i].call()
		await get_tree().create_timer(0.9, false).timeout
	spawn_slime_ded_signal()


func spawn_strong_wind_faster() -> void:
	# Set up
	var enemies = [spawn_slime, spawn_slime,spawn_slime,spawn_bomby,spawn_bomby,spawn_bomby]
	enemies.shuffle()
	kaisouko.play_attack()
	$AnimationPlayer.play("strong_wind")
	%ParallaxClouds.SPEED = -1000
	$Chiichan.is_strong_wind = true

	await get_tree().create_timer(1, false).timeout

	# Obstacles
	for i in range(randi_range(3, 5)):
		enemies[i].call()
		await get_tree().create_timer(0.5, false).timeout
	spawn_slime_ded_signal()


func spawn_slime() -> void:
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position

	add_child(slime1)
	slime1.throw_slime(Vector2(-2000, -2000))


func spawn_slime_ded_signal() -> void:
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position
	slime1.connect("ded", spawner)

	add_child(slime1)
	slime1.throw_slime(Vector2(-2000, -2000))


	# turns off wind
	$AnimationPlayer.stop()
	%ParallaxClouds.SPEED = -300
	$Chiichan.is_strong_wind = false


func spawn_bomby() -> void:
	var bomby = BOMBY.instantiate()
	bomby.position = $"Markers/EnemySpawnPos".position

	bomby.throw_bomb(Vector2(-2000, -2000))
	add_child(bomby)


func spawn_ora_ora() -> void:
	var slime = SLIME.instantiate()
	slime.position = $"Markers/EnemySpawnPos2".position
	slime.connect("ded", spawner)

	kaisouko.play_attack()
	await get_tree().create_timer(0.2, false).timeout
	add_child(slime)
	slime.activate_speed()
	slime.throw_slime(Vector2(-3000, -1200))


func smol_shake() -> void:
	$"%CameraPlayer".stop()
	$"%CameraPlayer".play("smol_shake")


func smol_shake_offset() -> void:
	$"%CameraPlayer2".stop()
	$"%CameraPlayer2".play("smol_shake_3")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start":
		$YouWinLabel/AnimationPlayer.play("loop")
		$YouWinLabel/AnimationPlayer2.play("start")
		$YouWinLabel/hitSpark.visible = true

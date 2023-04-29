extends Node


func _ready():
	pass


func spawn_triple01() -> void:
	var bomby = BOMBY.instantiate()
	bomby.position = $"Markers/EnemySpawnPos2".position

	var rocky = ROCKY.instantiate()
	rocky.position = $"Markers/EnemySpawnPos".position

	var slime = SLIME.instantiate()
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos".position

	# add bomby
	bomby.throw_bomb(Vector2(-2000, -2000))
	add_child(bomby)
	await get_tree().create_timer(0.3, false).timeout

	# add rocky
	add_child(rocky)
	await get_tree().create_timer(0.2, false).timeout

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
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime2)
	slime2.throw_slime(Vector2(-2000, -2000))
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime3)
	slime3.throw_slime(Vector2(-1900, -1900))


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


func spawn_triple03() -> void:
	var node1 = BOMBY.instantiate()
	node1.position = $"Markers/EnemySpawnPos2".position

	var node2 = BOMBY.instantiate()
	node2.position = $"Markers/EnemySpawnPos2".position

	var node3 = BOMBY.instantiate()
	node3.connect("ded", spawner)
	node3.position = $"Markers/EnemySpawnPos2".position

	add_child(node1)
	node1.throw_bomb(Vector2(-2000, -2500))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node2)
	node2.throw_bomb(Vector2(-2000, -2000))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node3)
	node3.throw_bomb(Vector2(-1900, -1900))


func spawn_triple04() -> void:
	var node1 = BOMBY.instantiate()
	node1.position = $"Markers/EnemySpawnPos2".position

	var node2 = BOMBY.instantiate()
	node2.position = $"Markers/EnemySpawnPos2".position

	var node3 = BOMBY.instantiate()
	node3.connect("ded", spawner)
	node3.position = $"Markers/EnemySpawnPos2".position

	add_child(node3)
	node3.throw_bomb(Vector2(-1000, -1000))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node2)
	node2.throw_bomb(Vector2(-1900, -1900))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node1)
	node1.throw_bomb(Vector2(-2200, -2200))


func spawn_triple05() -> void:
	var slime1 = SLIME.instantiate()
	slime1.position = $"Markers/EnemySpawnPos".position

	var slime3 = SLIME.instantiate()
	slime3.connect("ded", spawner)
	slime3.position = $"Markers/EnemySpawnPos".position

	add_child(slime1)
	await get_tree().create_timer(0.1, false).timeout

	add_child(slime3)


func spawn_five_bombs() -> void:
	var node1 = BOMBY.instantiate()
	node1.position = $"Markers/EnemySpawnPos2".position

	var node2 = BOMBY.instantiate()
	node2.position = $"Markers/EnemySpawnPos2".position

	var node3 = BOMBY.instantiate()
	node3.position = $"Markers/EnemySpawnPos2".position

	var node4 = BOMBY.instantiate()
	node4.position = $"Markers/EnemySpawnPos2".position

	var node5 = BOMBY.instantiate()
	node5.connect("ded", spawner)
	node5.position = $"Markers/EnemySpawnPos2".position

	add_child(node1)
	node1.throw_bomb(Vector2(-1000, -1000))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node2)
	node2.throw_bomb(Vector2(-1300, -1300))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node3)
	node3.throw_bomb(Vector2(-1500, -1500))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node4)
	node4.throw_bomb(Vector2(-1900, -1900))
	await get_tree().create_timer(0.3, false).timeout

	add_child(node5)
	node5.throw_bomb(Vector2(-2300, -2300))
	await get_tree().create_timer(0.3, false).timeout


func spawn_five_ground_bombs() -> void:
	var node1 = BOMBY.instantiate()
	node1.position = $"Markers/EnemySpawnPos".position

	var node2 = BOMBY.instantiate()
	node2.position = $"Markers/EnemySpawnPos".position

	var node3 = BOMBY.instantiate()
	node3.position = $"Markers/EnemySpawnPos".position

	var node4 = BOMBY.instantiate()
	node4.position = $"Markers/EnemySpawnPos".position

	var node5 = BOMBY.instantiate()
	node5.connect("ded", spawner)
	node5.position = $"Markers/EnemySpawnPos".position

	add_child(node1)
	await get_tree().create_timer(0.2, false).timeout

	add_child(node2)
	await get_tree().create_timer(0.2, false).timeout

	add_child(node3)
	await get_tree().create_timer(0.2, false).timeout

	add_child(node4)
	await get_tree().create_timer(0.2, false).timeout

	add_child(node5)


func spawn_2rock_1speed() -> void:
	var rocky = ROCKY.instantiate()
	rocky.position = $"Markers/EnemySpawnPos".position

	var rocky2 = ROCKY.instantiate()
	rocky2.position = $"Markers/EnemySpawnPos".position

	var bomby = BOMBY.instantiate()
	bomby.activate_speed()
	bomby.connect("ded", spawner)
	bomby.position = $"Markers/EnemySpawnPos".position

	add_child(bomby)
	await get_tree().create_timer(0.1, false).timeout

	add_child(rocky)
	await get_tree().create_timer(0.2, false).timeout

	add_child(rocky2)


func spawn_2bomb_rock_slime() -> void:
	var bomby1 = BOMBY.instantiate()
	bomby1.position = $"Markers/EnemySpawnPos".position

	var bomby2 = BOMBY.instantiate()
	bomby2.position = $"Markers/EnemySpawnPos".position

	var rocky = ROCKY.instantiate()
	rocky.position = $"Markers/EnemySpawnPos".position

	var slime = SLIME.instantiate()
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos".position

	add_child(bomby1)
	await get_tree().create_timer(1, false).timeout

	add_child(rocky)
	await get_tree().create_timer(0.3, false).timeout

	add_child(slime)


func spawn_slime_rocks() -> void:
	var rocky = ROCKY.instantiate()
	rocky.position = $"Markers/EnemySpawnPos".position

	var rocky2 = ROCKY.instantiate()
	rocky2.connect("ded", spawner)
	rocky2.position = $"Markers/EnemySpawnPos".position

	var slime = SLIME.instantiate()
	slime.position = $"Markers/EnemySpawnPos".position

	var slime2 = SLIME.instantiate()
	slime2.position = $"Markers/EnemySpawnPos".position

	add_child(slime)
	await get_tree().create_timer(0.2, false).timeout

	add_child(rocky)
	await get_tree().create_timer(0.8, false).timeout

	add_child(slime2)
	await get_tree().create_timer(0.2, false).timeout

	add_child(rocky2)


func spawn_2rock_1slime() -> void:
	var rocky = ROCKY.instantiate()
	rocky.position = $"Markers/EnemySpawnPos".position

	var rocky2 = ROCKY.instantiate()
	rocky2.position = $"Markers/EnemySpawnPos".position

	var slime = SLIME.instantiate()
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos".position

	add_child(rocky)
	await get_tree().create_timer(0.1, false).timeout

	add_child(rocky2)
	await get_tree().create_timer(0.5, false).timeout

	add_child(slime)
	slime.activate_speed()


func spawn_boom_slime_sword() -> void:
	var slime = SLIME.instantiate()
	slime.is_boom_slime = true
	slime.connect("ded", spawner)
	slime.position = $"Markers/EnemySpawnPos2".position

	add_child(slime)
	slime.throw_slime(Vector2(-3000, -2700))

extends CharacterBody2D


var speed: int = 100000
var jump_power = 2000
var gravity_power = 30
@onready var chiichan = $"../Chiichan"
var BLUE_SPARK = preload("res://nodes/particles/blue_spark.tscn")
var RED_SPARK = preload("res://nodes/particles/red_spark.tscn")


# Config
var is_moving = true

# Signals
signal ded


func _physics_process(delta):
	# Add gravity and calculate movements
	move_left(delta)
	gravity()
	move_and_slide()


func jump() -> void:
	$"AnimationPlayer".play("jump")


func fake_jump() -> void:
	$"AnimationPlayer".play("fake_jump")


# Used in jump animation
func jump_helper() -> void:
	velocity += Vector2(0, -jump_power)


func gravity():
	if not is_on_floor():
		velocity += Vector2(0, gravity_power)


func move_left(delta) ->  void:
	if is_moving:
		velocity = Vector2(-speed * delta, velocity.y)


func hurt():
	$"AnimationPlayer".play("hurt")


func turn_off_all_collision():
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000


func turn_hit_boss_collision():
	collision_layer = 0b00000000000000000100
	collision_mask = 0b00000000000000010000


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("ded")
	queue_free()


func _on_jump_timer_timeout():
	var actions = [jump, fake_jump]
	actions.pick_random().call()


func _on_area_2d_body_entered(body):
	if body.is_in_group("chiichan"):
		hurt()

		# push chiichan 
		body.set_state(body.States.RUNNING) # chiichan can't parry this
		body.push(Vector2(-2000, -1000))

extends Node


var phase_helper = -1 # Use Phases enum

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func save_checkpoint() -> void:
	$"/root/Config".checkpoint  = phase_helper - 1


func get_stage_path() -> String:
	return "res://scenes/volcano.tscn"

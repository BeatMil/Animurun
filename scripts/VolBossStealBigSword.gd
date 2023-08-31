extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_steal_sword():
	$AnimationPlayer.play("steal_sword")

func despawn_sword():
	$"../Taiga/sword".queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "steal_sword":
		$"../Chiichan".play_stage1_clear_b()

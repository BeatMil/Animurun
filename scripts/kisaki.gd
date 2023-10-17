extends RigidBody2D


var is_angry = false


func push_chiichan(): # used by wall.gd
	$AnimationPlayer.play("attack")


func play_attack():
	$AnimationPlayer.play("attack")


func play_angry():
	$AnimationPlayer.play("angry")


# Used by $AnimationPlayer.play("angry")
func continue_spawner():
	$"..".spawner()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("idle")


func _on_body_entered(body):
	if body.is_in_group("slime"):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("hurt")
		$"..".kisaki_hp -= 1


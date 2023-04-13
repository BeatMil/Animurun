extends ColorRect


func freeze() -> void:
	$AnimationPlayer.play("dim")


func unfreeze() -> void:
	$AnimationPlayer.play("undim")

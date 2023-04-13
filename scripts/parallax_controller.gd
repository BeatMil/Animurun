extends ParallaxBackground


# Configs
var is_freeze: bool


func freeze(): # used for cool cinimatic
	is_freeze = true


func unfreeze():
	is_freeze = false

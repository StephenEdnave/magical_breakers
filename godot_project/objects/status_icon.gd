extends Node2D

var current_status = null

func _ready():
	$AnimationPlayer.play("SETUP")
	change_status(GlobalConstants.HEALTH_STATUS.NORMAL)


func change_status(new_status):
	match current_status:
		GlobalConstants.HEALTH_STATUS.FIRE:
			$AnimationPlayer.play("SETUP")
			visible = false
	match new_status:
		GlobalConstants.HEALTH_STATUS.FIRE:
			$AnimationPlayer.play("burn")
			visible = true
	
	current_status = new_status
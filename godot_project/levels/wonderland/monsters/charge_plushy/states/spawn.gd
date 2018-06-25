extends "res://utils/states/state.gd"


func enter():
	owner.Anim.play("spawn")


func _on_animation_finished(anim_name):
	assert anim_name == "spawn"
	return owner.STATE_IDS.ROAM_SEQUENCE
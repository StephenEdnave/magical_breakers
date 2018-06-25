extends "res://utils/states/state.gd"


func enter():
	owner.Anim.play("charge_prepare")


func _on_animation_finished(anim_name):
	emit_signal("finished")
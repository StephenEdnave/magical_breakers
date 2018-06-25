extends "res://utils/states/state.gd"

export (float) var SPEED = 60.0
var direction = Vector2()


func enter():
	owner.Anim.play("bump")


func update(delta):
	owner.move_and_slide(SPEED * direction)


func _on_animation_finished(anim_name):
	assert anim_name == "bump"
	emit_signal("finished")


func _on_charge_direction_decided(_direction):
	direction = -_direction
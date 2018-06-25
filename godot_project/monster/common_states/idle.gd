# 1 of sequence: RoamSequence
extends "res://utils/states/state.gd"

export (bool) var roam = true
export (float) var duration = 1.5
var timer


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	add_child(timer)


func enter():
	owner.Anim.play("idle")
	
	if roam:
		timer.start()


func exit():
	timer.stop()


func update(delta):
	if roam and timer.time_left <= 0:
		emit_signal("finished")
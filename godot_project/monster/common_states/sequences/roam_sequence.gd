# States in sequence: Idle --> Roam
extends "res://utils/states/sequence.gd"

export (float) var SPOT_RANGE = 5000
var start_position = Vector2()


func enter():
	start_position = owner.global_position
	.enter()


func update(delta):
	if owner.global_position.distance_to(owner.target_position) < SPOT_RANGE:
		if not owner.has_target:
			return
		return owner.STATE_IDS.SPOT
	
	if finished:
		return owner.STATE_IDS.ROAM_SEQUENCE
	
	.update(delta)
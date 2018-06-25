extends "res://monster/common_states/sequences/roam_sequence.gd"
# States in sequence: Idle --> Roam


func update(delta):
	if finished:
		return owner.STATE_IDS.ATTACK
	
	.update(delta)
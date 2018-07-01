extends "res://utils/states/sequence.gd"


func update(delta):
	.update(delta)
	
	if finished:
		return owner.STATE_IDS.ROAM_SEQUENCE
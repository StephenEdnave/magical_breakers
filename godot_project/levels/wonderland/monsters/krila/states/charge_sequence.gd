extends "res://utils/states/sequence.gd"
# States in sequence: Idle --> Roam


func update(delta):
	.update(delta)
	
	if finished:
		return owner.STATE_IDS.ROAM_SEQUENCE
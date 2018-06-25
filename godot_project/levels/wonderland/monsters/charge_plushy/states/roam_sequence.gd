extends "res://monster/common_states/sequences/roam_sequence.gd"
# States in sequence: Idle --> Roam


func update(delta):
	if owner.global_position.distance_to(owner.target_position) < SPOT_RANGE:
		if not owner.has_target:
			return
		return owner.STATE_IDS.SPOT
	
	if finished:
		return owner.STATE_IDS.CHARGE_SEQUENCE
	
	.update(delta)
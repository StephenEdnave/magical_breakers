extends "res://monster/common_states/motion/attack.gd"


func update(delta):
	if finished:
		owner.STATES[owner.STATE_IDS.END_PHASE].velocity = velocity
		return owner.STATE_IDS.END_PHASE
	
	# Move if carrying momentum
	move()
extends "res://monster/common_states/motion/attack.gd"


func update(delta):
	if finished:
		host.STATES[host.STATE_IDS.END_PHASE].velocity = velocity
		return host.STATE_IDS.END_PHASE
	
	# Move if carrying momentum
	move(host)
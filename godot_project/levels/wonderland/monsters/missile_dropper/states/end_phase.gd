extends 'res://monster/common_states/motion/end_phase.gd'

const offset = Vector2(0, 500)

func enter():
	target_position = owner.global_position + offset
	return_slow_radius = owner.position.distance_to(owner.start_position) / 2
	owner.get_node("RayCast2D").visible = true
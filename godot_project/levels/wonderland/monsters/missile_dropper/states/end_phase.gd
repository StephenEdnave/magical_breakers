extends 'res://monster/common_states/motion/end_phase.gd'

const offset = Vector2(0, 500)

func enter():
	target_position = host.global_position + offset
	return_slow_radius = host.position.distance_to(host.start_position) / 2
	host.get_node("RayCast2D").visible = true
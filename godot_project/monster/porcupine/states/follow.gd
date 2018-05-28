extends 'state.gd'

export(float) var CHARGE_RANGE = 300.0
export(float) var FOLLOW_RANGE = 650.0
export(float) var max_follow_speed = 320.0


# Initialize the state. E.g. change the animation
func enter(host):
	pass


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("RayCast2D").visible = false


func handle_input(host, event):
	pass


func update(host, delta):
	if not host.has_target:
		return RETURN
	host.velocity = host.follow(host.velocity, host.target_position, max_follow_speed)
	host.move_and_slide(host.velocity)
	if host.position.distance_to(host.target_position) <= CHARGE_RANGE:
		return CHARGE_PREPARE
	if host.position.distance_to(host.target_position) > FOLLOW_RANGE:
		return RETURN
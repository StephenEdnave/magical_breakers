extends 'motion.gd'

export(float) var SPOT_RANGE = 3000.0

export(float) var max_return_speed = 200.0
var return_slow_radius = 0.0


# Initialize the state. E.g. change the animation
func enter():
	return_slow_radius = host.global_position.distance_to(host.start_position) / 2


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func update(delta):
	velocity = arrive_to(velocity, host.start_position, return_slow_radius, max_return_speed, true)
	move()
	host.get_node("BodyPivot").scale.x = look_direction.x
	if host.global_position.distance_to(host.start_position) < ARRIVE_DISTANCE:
		return host.STATE_IDS.IDLE
	elif host.global_position.distance_to(host.target_position) < SPOT_RANGE:
		if not host.has_target:
			return
		return host.STATE_IDS.SPOT
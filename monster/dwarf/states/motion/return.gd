extends 'motion.gd'

var SPOT_RANGE = 320.0
var ARRIVE_DISTANCE = 6.0

var return_slow_radius = 0.0
export(float) var max_return_speed = 200.0


func setup(_spot_range, _arrive_distance):
	SPOT_RANGE = _spot_range
	ARRIVE_DISTANCE = _arrive_distance


# Initialize the state. E.g. change the animation
func enter(host):
	return_slow_radius = host.position.distance_to(host.start_position) / 2
	host.get_node("RayCast2D").visible = true


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("RayCast2D").visible = false


func handle_input(host, event):
	pass


func update(host, delta):
	velocity = host.arrive_to(velocity, host.start_position, return_slow_radius, max_return_speed, true)
	move(host)
	host.get_node("BodyPivot").scale.x = look_direction.x
	if host.position.distance_to(host.start_position) < ARRIVE_DISTANCE:
		return IDLE
	elif host.position.distance_to(host.target_position) < SPOT_RANGE:
		return SPOT
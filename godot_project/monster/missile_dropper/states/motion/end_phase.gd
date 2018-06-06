extends 'motion.gd'

var DISTANCE = 500.0

var return_slow_radius = 0.0
export(float) var max_return_speed = 800.0
var target_position = Vector2()

# Initialize the state. E.g. change the animation
func enter(host):
	target_position = host.global_position - Vector2(0, DISTANCE)
	return_slow_radius = host.global_position.distance_to(host.start_position) / 2
	host.get_node("RayCast2D").visible = true


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("RayCast2D").visible = false


func handle_input(host, event):
	pass


func update(host, delta):
	velocity = arrive_to(host, velocity, target_position, return_slow_radius, max_return_speed, true)
	move(host)
	host.get_node("BodyPivot").scale.x = look_direction.x
	if host.global_position.distance_to(target_position) < ARRIVE_DISTANCE:
		return DIE
extends 'state.gd'

export (float) var FOLLOW_RANGE = 300.0

# Initialize the state. E.g. change the animation
func enter(host):
	pass


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	if host.position.distance_to(host.target_position) <= FOLLOW_RANGE:
		return FOLLOW
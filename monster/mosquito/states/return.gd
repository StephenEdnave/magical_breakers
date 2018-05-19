extends 'state.gd'


# Initialize the state. E.g. change the animation
func enter(host):
	pass


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	host.velocity = host.arrive_to(host.velocity, host.start_position)
	host.move_and_slide(host.velocity)
	host.rotation = host.velocity.angle()
	
	if host.position.distance_to(host.target_position) < host.ARRIVE_DISTANCE:
		return IDLE
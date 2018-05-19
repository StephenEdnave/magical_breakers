extends 'state.gd'

export (float) var MAX_FOLLOW_RANGE = 400.0
export (float) var MAX_FLY_SPEED = 360.0


# Initialize the state. E.g. change the animation
func enter(host):
	host.get_node("RayCast2D").visible = true


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	if host.position.distance_to(host.target_position) > MAX_FOLLOW_RANGE:
		return RETURN
	
	host.velocity = host.follow(host.velocity, host.target_position, MAX_FLY_SPEED)
	host.move_and_slide(host.velocity)
	host.rotation = host.velocity.angle()
	
	if host.get_slide_count() == 0:
		return
	
	var body = host.get_slide_collision(0).collider
	if body.is_in_group('character'):
		body.take_damage(host, 4, GlobalConstants.HEALTH_EFFECT.NONE, GlobalConstants.HEALTH_DAMAGE_TYPE.NONE, 10.0)
		return DIE
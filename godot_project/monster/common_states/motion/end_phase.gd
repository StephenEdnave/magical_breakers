extends 'motion.gd'


var return_slow_radius = 0.0
export(float) var max_return_speed = 800.0


# Initialize the state. E.g. change the animation
func enter():
	target_position = owner.start_position
	return_slow_radius = owner.position.distance_to(owner.start_position) / 2
	owner.get_node("RayCast2D").visible = true


# Clean up the state. Reinitialize values like a timer
func exit():
	owner.get_node("RayCast2D").visible = false


func update(delta):
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, owner, MASS, return_slow_radius, max_return_speed, true)
	move()
	owner.get_node("BodyPivot").scale.x = look_direction.x
	if owner.global_position.distance_to(owner.start_position) < ARRIVE_DISTANCE:
		return owner.STATE_IDS.DIE
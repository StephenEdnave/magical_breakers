extends 'motion.gd'

export(float) var SPOT_RANGE = 3000.0

export(float) var max_return_speed = 200.0
var return_slow_radius = 0.0


# Initialize the state. E.g. change the animation
func enter():
	return_slow_radius = owner.global_position.distance_to(owner.start_position) / 2


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func update(delta):
	velocity = Steering.arrive_to(velocity, owner.global_position, owner.start_position, owner, return_slow_radius, max_return_speed, true)
	move()
	owner.get_node("BodyPivot").scale.x = look_direction.x
	if owner.global_position.distance_to(owner.start_position) < ARRIVE_DISTANCE:
		return owner.STATE_IDS.IDLE
	elif owner.global_position.distance_to(owner.target_position) < SPOT_RANGE:
		if not owner.has_target:
			return
		return owner.STATE_IDS.SPOT
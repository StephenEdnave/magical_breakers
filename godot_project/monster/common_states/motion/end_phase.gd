extends 'motion.gd'


# Initialize the state. E.g. change the animation
func enter():
	target_position = owner.start_position
	SLOW_RADIUS = owner.position.distance_to(owner.start_position) / 2
	owner.get_node("RayCast2D").visible = true


# Clean up the state. Reinitialize values like a timer
func exit():
	owner.get_node("RayCast2D").visible = false


func update(delta):
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, owner, MASS, SLOW_RADIUS, MAX_SPEED, true)
	move()
	owner.get_node("BodyPivot").scale.x = look_direction.x
	
	if sign(look_direction.x) == sign(velocity.x):
		if not owner.Anim.current_animation == "move_forward":
			owner.Anim.play("move_forward")
	else:
		if not owner.Anim.current_animation == "move_backward":
			owner.Anim.play("move_backward")
	
	
	if owner.global_position.distance_to(owner.start_position) < ARRIVE_DISTANCE:
		owner.queue_free()
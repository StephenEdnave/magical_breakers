extends 'on_ground.gd'

export (float) var MAX_WALK_SPEED = 450
var speed = 0.0
var acceleration = 75


func enter():
	speed = MAX_WALK_SPEED
	host.Anim.play("walk_forward")


func exit():
	host.STATES[IDLE].velocity = velocity


func handle_input(event):
	return .handle_input(event)


func update(delta):
	# Input
	if host.is_player and Input.is_action_pressed("dash"):
		return DASH
	
	get_input_direction()
	if not input_direction:
		return IDLE
	
	steering(speed, acceleration)
	move()
	
	if host.target:
		var vector_to_target = host.target_position - host.global_position
		if sign(vector_to_target.x) == sign(velocity.x):
			if host.Anim.assigned_animation != "walk_forward":
				host.Anim.play("walk_forward")
		elif sign(vector_to_target.x) != sign(velocity.x):
			if host.Anim.assigned_animation != "walk_backward":
				host.Anim.play("walk_backward")
	else:
		if host.Anim.assigned_animation != "walk_forward":
			host.Anim.play("walk_forward")
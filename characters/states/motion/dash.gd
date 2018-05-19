extends 'motion.gd'

export (float) var MAX_DASH_SPEED = 1000
export (float) var MIN_DASH_SPEED = 600
var speed = 0.0
var acceleration = 40


func enter(host):
	speed = MAX_DASH_SPEED
	host.Anim.play("dash_forward")
	
	get_input_direction(host)
	velocity = input_direction * speed


func exit(host):
	host.STATES[WALK].velocity = velocity
	host.get_node("BodyPivot").rotation_degrees = 0


func handle_input(host, event):
	return .handle_input(host, event)


func update(host, delta):
	# Input
	if not Input.is_action_pressed("dash"):
		return WALK
	
	get_input_direction(host)
	if not input_direction:
		input_direction = last_move_direction
	
	# Steering
	steering(host, speed, acceleration)
	if velocity.length() < MIN_DASH_SPEED:
		velocity = velocity.normalized() * MIN_DASH_SPEED
	move(host)
	
	
	var angle = rad2deg(velocity.angle())
	if angle < -90 or 90 < angle: # host facing left
		angle -= 180
	host.get_node("BodyPivot").rotation_degrees = angle
	
	if host.Anim.assigned_animation != "dash_forward":
		host.Anim.play("dash_forward")
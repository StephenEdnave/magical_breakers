extends "res://utils/states/state.gd"

export(float) var ARRIVE_DISTANCE = 6.0
export(float) var SLOW_RADIUS = 200.0
export(float) var MAX_SPEED = 300.0
export(float) var MASS = 8.0

export (bool) var ALWAYS_FACE_PLAYER = false

var last_move_direction = Vector2(1, 0)
var velocity = Vector2()
var look_direction = Vector2()

var target_position = Vector2()

func move():
	last_move_direction = Vector2(sign(velocity.x), sign(velocity.y))
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	update_look_direction()


func update_look_direction():
	if ALWAYS_FACE_PLAYER:
		look_direction.x = sign(owner.target_position.x - owner.global_position.x)
	else:
		if last_move_direction.x == 0:
			look_direction.x = sign(owner.target_position.x - owner.global_position.x)
		else:
			look_direction.x = last_move_direction.x
#		if last_move_direction.y != 0:
#			look_direction.y = last_move_direction.y
	owner.get_node("BodyPivot").scale = Vector2(look_direction.x, 1)
#	owner.get_node("WeaponPivot").scale = Vector2(look_direction.x, 1)


func follow(velocity, target_position, max_speed):
	var desired_velocity = (target_position - owner.global_position).normalized() * max_speed

	var push = Steering.calculate_avoid_force(owner, desired_velocity)
	var steering = (desired_velocity - velocity + push) / MASS

	return velocity + steering
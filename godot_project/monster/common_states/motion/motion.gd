extends "../state.gd"

export(float) var ARRIVE_DISTANCE = 6.0
export(float) var DEFAULT_SLOW_RADIUS = 200.0
export(float) var DEFAULT_MAX_SPEED = 300.0
export(float) var MASS = 8.0

var last_move_direction = Vector2(1, 0)
var velocity = Vector2()
var look_direction = Vector2()


func move():
	last_move_direction = Vector2(sign(velocity.x), sign(velocity.y))
	host.move_and_slide(velocity, Vector2(), 5, 2)
	update_look_direction()


func update_look_direction():
	if last_move_direction.x != 0:
		look_direction.x = last_move_direction.x
	if last_move_direction.y != 0:
		look_direction.y = last_move_direction.y
	host.get_node("BodyPivot").scale = Vector2(look_direction.x, 1)
#	host.get_node("WeaponPivot").scale = Vector2(look_direction.x, 1)


func follow(velocity, target_position, max_speed):
	var desired_velocity = (target_position - host.global_position).normalized() * max_speed

	var push = calculate_avoid_force(desired_velocity)
	var steering = (desired_velocity - velocity + push) / MASS

	return velocity + steering


func arrive_to(velocity, target_position, slow_radius=DEFAULT_SLOW_RADIUS, max_speed=DEFAULT_MAX_SPEED, avoid=false):
	var distance_to_target = host.global_position.distance_to(target_position)

	var desired_velocity = (target_position - host.global_position).normalized() * max_speed
	if distance_to_target < slow_radius:
		desired_velocity *= (distance_to_target / slow_radius) * .75 + .25

	var push = calculate_avoid_force(desired_velocity) if avoid else Vector2()
	var steering = (desired_velocity - velocity + push) / MASS

	return velocity + steering


func calculate_avoid_force(desired_velocity):
	var raycast = host.get_node("RayCast2D")
	raycast.cast_to = desired_velocity.normalized() * 200
	raycast.force_raycast_update()
	var push = Vector2()
	if raycast.is_colliding():
		var normal = raycast.get_collision_normal()
		var point = raycast.get_collision_point()
		push = normal.rotated(PI/2) * 300 * (1 - host.global_position.distance_to(point) / 200)
	return push
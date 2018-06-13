extends Node

const DEFAULT_MASS = 2.0
const DEFAULT_SLOW_RADIUS = 200.0
const DEFAULT_MAX_SPEED = 300.0


func arrive_to(velocity, 
			   position_current, 
			   position_target,
			   host,
			   mass=DEFAULT_MASS, 
			   slow_radius=DEFAULT_SLOW_RADIUS, 
			   max_speed=DEFAULT_MAX_SPEED,
			   avoid=false):
	"""
	Calculates and returns a new velocity with the arrive steering behavior arrived based on
	an existing velocity (Vector2), the object's current and target positions (Vector2)
	"""
	var distance_to_target = position_current.distance_to(position_target)

	var desired_velocity = (position_target - position_current).normalized() * max_speed
	if distance_to_target < slow_radius:
		desired_velocity *= (distance_to_target / slow_radius) * .75 + .25
	var push = calculate_avoid_force(host, desired_velocity) if avoid else Vector2()
	var steering = (desired_velocity - velocity + push) / mass

	return velocity + steering


func calculate_avoid_force(host, desired_velocity):
	var raycast = host.get_node("RayCast2D")
	raycast.cast_to = desired_velocity.normalized() * 200
	raycast.force_raycast_update()
	var push = Vector2()
	if raycast.is_colliding():
		var normal = raycast.get_collision_normal()
		var point = raycast.get_collision_point()
		push = normal.rotated(PI/2) * 300 * (1 - host.global_position.distance_to(point) / 200)
	return push
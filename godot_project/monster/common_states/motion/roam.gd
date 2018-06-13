extends 'motion.gd'

export (float) var max_roam_speed = 200.0
export (float) var ROAM_RADIUS = 140.0
export (float) var SPOT_RANGE = 3000.0
var roam_target_position = Vector2()
var roam_slow_radius = 0.0


# Initialize the state. E.g. change the animation
func enter():
	host.Anim.play("walk")
	randomize()
	var random_angle = randf() * 2 * PI
	randomize()
	var random_radius = (randf() * ROAM_RADIUS) / 2 + ROAM_RADIUS / 2
	roam_target_position = host.start_position + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)
	roam_slow_radius = roam_target_position.distance_to(host.start_position) / 2


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func update(delta):
	velocity = arrive_to(velocity, roam_target_position, roam_slow_radius, max_roam_speed)
	move()
	host.get_node("BodyPivot").scale.x = look_direction.x
	if host.global_position.distance_to(roam_target_position) < ARRIVE_DISTANCE:
		return host.STATE_IDS.IDLE
	elif host.global_position.distance_to(host.target_position) < host.SPOT_RANGE:
		if not host.has_target:
			return
		return host.STATE_IDS.SPOT
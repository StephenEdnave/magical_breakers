extends 'motion.gd'

export(float) var max_roam_speed = 200.0
export(float) var ROAM_RADIUS = 140.0
var roam_target_position = Vector2()
var roam_slow_radius = 0.0
var SPOT_RANGE = 320.0


func setup(_spot_range):
	SPOT_RANGE = _spot_range


# Initialize the state. E.g. change the animation
func enter(host):
	host.Anim.play("walk")
	randomize()
	var random_angle = randf() * 2 * PI
	randomize()
	var random_radius = (randf() * ROAM_RADIUS) / 2 + ROAM_RADIUS / 2
	roam_target_position = host.start_position + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)
	roam_slow_radius = roam_target_position.distance_to(host.start_position) / 2


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	velocity = host.arrive_to(velocity, roam_target_position, roam_slow_radius, max_roam_speed)
	move(host)
	host.get_node("BodyPivot").scale.x = look_direction.x
	if host.global_position.distance_to(roam_target_position) < host.ARRIVE_DISTANCE:
		return IDLE
	elif host.global_position.distance_to(host.target_position) < host.SPOT_RANGE:
		if not host.has_target:
			return
		return SPOT
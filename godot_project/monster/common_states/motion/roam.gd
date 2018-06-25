# 2 of sequence: RoamSequence
extends 'motion.gd'

export (float) var MAX_SPEED = 300.0
export (float) var ROAM_RADIUS = 140.0
export (float) var SLOW_RADIUS = 200.0


func enter():
	owner.Anim.play("walk")
	target_position = calculate_new_target_position()


func calculate_new_target_position():
	randomize()
	var random_angle = randf() * 2 * PI
	randomize()
	var random_radius = (randf() * ROAM_RADIUS) / 2 + ROAM_RADIUS / 2
	return owner.start_position + Vector2(cos(random_angle), sin(random_angle)) * random_radius


func update(delta):
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, owner, MASS, SLOW_RADIUS, MAX_SPEED)
	move()
	owner.get_node("BodyPivot").scale.x = look_direction.x
	if owner.global_position.distance_to(target_position) < ARRIVE_DISTANCE:
		emit_signal("finished")
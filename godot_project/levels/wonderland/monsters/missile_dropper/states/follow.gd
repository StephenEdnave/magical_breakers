extends "res://monster/common_states/motion/follow.gd"


func update(delta):
	if not host.has_target:
		return host.STATE_IDS.RETURN
	
	if go_to_shoot:
		return host.STATE_IDS.SHOOT
	
	target_position = host.target_position + Vector2(0, 1) * DISTANCE_FROM_TARGET
	velocity = follow(velocity, target_position, max_follow_speed)
	move()
	host.get_node("BodyPivot").scale.x = look_direction.x
	
	if host.global_position.distance_to(host.target_position) > FOLLOW_RANGE:
		return host.STATE_IDS.RETURN
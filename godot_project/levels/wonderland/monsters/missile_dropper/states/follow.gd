extends "res://monster/common_states/motion/follow.gd"


func update(delta):
	if not owner.has_target:
		return owner.STATE_IDS.RETURN
	
	if go_to_shoot:
		return owner.STATE_IDS.ATTACK
	
	target_position = owner.target_position + Vector2(0, -1) * DISTANCE_FROM_TARGET
	velocity = follow(velocity, target_position, max_follow_speed)
	move()
	owner.get_node("BodyPivot").scale.x = look_direction.x
	
	if owner.global_position.distance_to(owner.target_position) > FOLLOW_RANGE:
		return owner.STATE_IDS.RETURN
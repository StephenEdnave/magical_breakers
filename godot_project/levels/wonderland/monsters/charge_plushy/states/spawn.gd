extends "res://monster/common_states/motion/motion.gd"

export (float) var DISTANCE = 300

func enter():
	owner.Anim.play("spawn")
	update_look_direction()
	target_position = owner.global_position + Vector2(DISTANCE * look_direction.x, 0)


func update(delta):
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, owner, MASS, SLOW_RADIUS, MAX_SPEED)
	move()
	owner.get_node("BodyPivot").scale.x = look_direction.x


func _on_animation_finished(name):
	assert name == "spawn"
	return owner.STATE_IDS.ROAM_SEQUENCE
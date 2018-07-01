extends "res://monster/common_states/motion/motion.gd"

signal direction_decided

export(float) var DISTANCE = 1000.0
var direction = Vector2()
var duration = 0.1

var hit_objects = []


func enter():
	owner.Anim.play("charge")
	direction = (owner.target_position - owner.global_position).normalized()
	emit_signal("direction_decided", direction)
	target_position = owner.global_position + direction * DISTANCE


func exit():
	hit_objects = []


func update(delta):
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, owner, MASS, SLOW_RADIUS, MAX_SPEED)
	move()
	
	if owner.global_position.distance_to(target_position) < ARRIVE_DISTANCE:
		emit_signal("finished")
		return
	
	if owner.get_slide_count() > 0:
		var body = owner.get_slide_collision(0)
		if body.collider_id in hit_objects:
			return
		hit_objects.append(body.collider_id)
		body.collider.take_damage(owner, "charge_plushy_charge")
		emit_signal("finished")
		return
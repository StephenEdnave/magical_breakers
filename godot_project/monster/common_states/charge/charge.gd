extends "res://utils/states/state.gd"

signal direction_decided

export (float) var SPEED = 1000.0
export(float) var DISTANCE = 1000.0
var direction = Vector2()
var duration = 0.1

var timer = null
var finished = false

var hit_objects = []


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	duration = DISTANCE / SPEED
	timer.wait_time = duration
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)


func enter():
	owner.Anim.play("charge")
	direction = (owner.target_position - owner.global_position).normalized()
	emit_signal("direction_decided", direction)
	finished = false
	timer.start()


func exit():
	hit_objects = []


func update(delta):
	owner.move_and_slide(SPEED * direction)
	
	if finished:
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


func _on_timeout():
	finished = true
extends "res://utils/states/state.gd"

var direction = Vector2()
var force = 10.0
var duration = 0.4

var timer = null
var finished = false


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)


func setup(_direction, attack_name):
	direction = _direction
	force = Attacks.attacks[attack_name].knockback_force
	duration = Attacks.attacks[attack_name].knockback_duration
	timer.wait_time = duration


func enter():
	owner.Anim.play("stagger")
	owner.Tween.interpolate_property(owner, "position", owner.position, owner.position + direction * force, duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	owner.Tween.start()
	finished = false
	timer.start()


func exit():
	owner.Anim.play("stagger_exit")


func update(delta):
	if finished:
		return owner.STATE_IDS.PREVIOUS_STATE


func _on_timeout():
	finished = true
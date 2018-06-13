extends 'state.gd'

var knockback_direction = Vector2()
var knockback_force = 10.0
var knockback_duration = 0.4

func setup(_knockback_direction, _knockback_force, _knockback_duration):
	knockback_direction = _knockback_direction
	knockback_force = _knockback_force
	knockback_duration = _knockback_duration


func enter():
	host.Anim.play("stagger")
	host.Tween.interpolate_property(host, "position", host.position, host.position + knockback_direction * knockback_force, knockback_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	host.Tween.start()


func exit():
	pass


func handle_input(event):
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	assert name == "stagger"
	return host.STATE_IDS.PREVIOUS_STATE
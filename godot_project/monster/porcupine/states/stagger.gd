extends 'state.gd'

var knockback_direction = Vector2()
var knockback_force = 10.0
const KNOCKBACK_DURATION = 0.4

func setup(_knockback_direction, _knockback_force):
	knockback_direction = _knockback_direction
	knockback_force = _knockback_force


func enter(host):
	host.Anim.play("stagger")
	host.Tween.interpolate_property(host, "position", host.position, host.position + knockback_direction * knockback_force, KNOCKBACK_DURATION, Tween.TRANS_QUART, Tween.EASE_OUT)
	host.Tween.start()


func exit(host):
	host.get_node("Tween").stop(host, "position")


func handle_input(host, event):
	pass


func update(host, delta):
	pass


func _on_animation_finished(host, name):
	if name == "stagger":
		return IDLE
extends '_state.gd'

var knockback_direction = Vector2()
var knockback_force = 10.0
var knockback_duration = 0.4

func setup(_knockback_direction, _knockback_force, _knockback_duration):
	knockback_direction = _knockback_direction
	knockback_force = _knockback_force
	knockback_duration = _knockback_duration


func enter(host):
	host.Anim.play("stagger")
	if host.primary_weapon:
		host.primary_weapon.stop_attack()
	if host.secondary_weapon:
		host.secondary_weapon.stop_attack()
	if host.special_weapon:
		host.special_weapon.stop_attack()
	host.Tween.interpolate_property(host, "position", host.position, host.position + knockback_direction * knockback_force, knockback_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	host.Tween.start()


func exit(host):
	host.get_node("Tween").stop(host, "position")


func handle_input(host, event):
	pass


func update(host, delta):
	pass


func _on_animation_finished(host, name):
	return IDLE
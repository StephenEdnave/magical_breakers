extends 'state.gd'

export(float) var BUMP_DISTANCE = 60.0
export(float) var BUMP_DURATION = 0.2
export(float) var MAX_BUMP_HEIGHT = 50.0
var tween_complete = false

var _host # For animating the tween


func setup(host):
	host.get_node("Tween").connect('tween_completed', self, '_on_tween_completed')
	_host = host


func enter(host):
	host.Anim.stop() # host.Anim.play("bump")
	var bump_direction = (host.position - host.target_position).normalized()
	host.get_node("Tween").interpolate_property(host, 'position', host.position, host.position + BUMP_DISTANCE * bump_direction, BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
	host.get_node("Tween").interpolate_method(self, '_animate_bump_height', 0, 1, BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
	host.get_node("Tween").start()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	if tween_complete:
		return CHARGE_COOLDOWN


func _on_tween_completed(object, key):
	tween_complete = true


func _animate_bump_height(progress):
	_host.get_node("BodyPivot").position.y = -pow(sin(progress * PI), 0.4) * MAX_BUMP_HEIGHT
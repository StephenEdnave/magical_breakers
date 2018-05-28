extends 'state.gd'

export(float) var CHARGE_COOLDOWN_DURATION = 0.6
var timeout = false


func enter(host):
	randomize()
	get_tree().create_timer(CHARGE_COOLDOWN_DURATION).connect('timeout', self, '_on_timeout')
	timeout = false


# Clean up the state. Reinitialize values like a timer
func exit(host):
	timeout = false


func handle_input(host, event):
	pass


func update(host, delta):
	if timeout:
		return FOLLOW


func _on_timeout():
	timeout = true
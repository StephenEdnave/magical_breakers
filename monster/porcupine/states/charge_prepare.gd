extends 'state.gd'

export(float) var CHARGE_PREPARE_DURATION = 0.3
var charge_start_position = Vector2()
var timeout = false


# Initialize the state. E.g. change the animation
func enter(host):
	charge_start_position = host.global_position
	get_tree().create_timer(CHARGE_PREPARE_DURATION).connect('timeout', self, '_on_timeout')


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.STATES[CHARGE].setup(host.global_position)
	timeout = false


func handle_input(host, event):
	pass


func update(host, delta):
	if timeout:
		return CHARGE


func _on_timeout():
	timeout = true
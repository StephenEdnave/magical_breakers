extends 'motion.gd'

var SPOT_RANGE = 320.0


func setup(_spot_range):
	SPOT_RANGE = _spot_range


# Initialize the state. E.g. change the animation
func enter(host):
	host.Anim.play('spot')
	var vector_to_target = host.target_position - host.global_position
	var look_direction = sign(vector_to_target.x)
	host.get_node("BodyPivot").scale.x = look_direction


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	pass


func _on_animation_finished(host, name):
	return host.STATE_IDS.FOLLOW
extends 'motion.gd'

# Initialize the state. E.g. change the animation
func enter():
	host.Anim.play('spot')
	var vector_to_target = host.target_position - host.global_position
	var look_direction = sign(vector_to_target.x)
	host.get_node("BodyPivot").scale.x = look_direction


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	return host.STATE_IDS.FOLLOW
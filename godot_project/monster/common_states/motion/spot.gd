extends 'motion.gd'

# Initialize the state. E.g. change the animation
func enter():
	owner.Anim.play('spot')
	var vector_to_target = owner.target_position - owner.global_position
	var look_direction = sign(vector_to_target.x)
	owner.get_node("BodyPivot").scale.x = look_direction


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	return owner.STATE_IDS.FOLLOW
extends 'motion.gd'

export(float) var CHARGE_PREPARE_DURATION = 0.3
var start_position = Vector2()
var timeout = false


# Initialize the state. E.g. change the animation
func enter(host):
	host.Anim.play("charge_prepare")
	start_position = host.global_position
	get_tree().create_timer(CHARGE_PREPARE_DURATION).connect('timeout', self, '_on_timeout')
	
	# Update sprite direction
	var charge_direction = (host.target_position - start_position).normalized()
	var look_direction = sign(charge_direction.x)
	host.get_node("BodyPivot").scale.x = look_direction
	var angle = rad2deg(atan2(charge_direction.y, charge_direction.x * look_direction))
	host.get_node("BodyPivot").get_node("Body").rotation_degrees = angle
	
	host.get_node("ChargePrepare").play()
	
	timeout = false


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.STATES[CHARGE].setup(host.global_position)
	timeout = false
	host.get_node("BodyPivot").get_node("Body").rotation_degrees = 0


func handle_input(host, event):
	pass


func update(host, delta):
	if timeout:
		return CHARGE


func _on_timeout():
	timeout = true
extends 'motion.gd'


func enter(host):
	host.Anim.play("idle")


func exit(host):
	host.STATES[WALK].velocity = velocity


func handle_input(host, event):
	return .handle_input(host, event)


func update(host, delta):
	get_input_direction(host)
	steering(host, 0, 50)
	move(host)
	if input_direction:
		return WALK
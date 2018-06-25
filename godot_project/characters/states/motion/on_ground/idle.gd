extends 'on_ground.gd'


func enter():
	owner.Anim.play("idle")


func exit():
	owner.STATES[WALK].velocity = velocity


func handle_input(event):
	return .handle_input(event)


func update(delta):
	get_input_direction()
	steering(0, 50)
	move()
	if input_direction:
		return WALK
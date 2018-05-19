extends "../motion.gd"


func handle_input(host, event):
	if event.is_action_pressed("primary_attack"):
		host.STATES[ATTACK].activate_weapon("primary_attack")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("secondary_attack"):
		host.STATES[ATTACK].activate_weapon("secondary_attack")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("special_attack"):
		host.STATES[ATTACK].activate_weapon("special_attack")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
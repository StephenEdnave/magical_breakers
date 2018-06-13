extends "../motion.gd"


func handle_input(event):
	if not host.is_player:
		return
	
	if event.is_action_pressed("primary_attack"):
		host.STATES[ATTACK].activate_weapon("primary_attack")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("secondary_attack"):
		host.STATES[ATTACK].activate_weapon("secondary_attack")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_1"):
		host.STATES[ATTACK].activate_weapon("skill_1")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_2"):
		host.STATES[ATTACK].activate_weapon("skill_2")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_3"):
		host.STATES[ATTACK].activate_weapon("skill_3")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_4"):
		host.STATES[ATTACK].activate_weapon("skill_4")
		host.STATES[ATTACK].velocity = velocity
		return ATTACK
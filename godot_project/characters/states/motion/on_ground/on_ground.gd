extends "../motion.gd"


func handle_input(event):
	if not owner.is_player:
		return
	
	if event.is_action_pressed("primary_attack"):
		owner.STATES[ATTACK].activate_weapon("primary_attack")
		owner.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("secondary_attack"):
		owner.STATES[ATTACK].activate_weapon("secondary_attack")
		owner.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_1"):
		owner.STATES[ATTACK].activate_weapon("skill_1")
		owner.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_2"):
		owner.STATES[ATTACK].activate_weapon("skill_2")
		owner.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_3"):
		owner.STATES[ATTACK].activate_weapon("skill_3")
		owner.STATES[ATTACK].velocity = velocity
		return ATTACK
	elif event.is_action_pressed("skill_4"):
		owner.STATES[ATTACK].activate_weapon("skill_4")
		owner.STATES[ATTACK].velocity = velocity
		return ATTACK
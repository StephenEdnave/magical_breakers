extends 'on_ground.gd'

var finished = false

var weapons = []
var weapon_active = []
export(Array) var weapon_paths

var inputs = {
	primary_weapon = 0, 
	secondary_weapon = 1, 
	skill_1 = 2, 
	skill_2 = 3, 
	skill_3 = 4, 
	skill_4 = 5 }

signal skill_used


func _ready():
	for weapon_path in weapon_paths:
		var weapon = load(weapon_path).instance()
		weapon.setup(host)
		weapon.connect("attack_started", self, "_on_Weapon_attack_started")
		weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
		weapon.connect("successful_hit", self, "_on_successful_hit")
		weapon.connect("attack_failed", self, "_on_Weapon_attack_failed")
		host.get_node("WeaponPivot").add_child(weapon)
		weapons.push_back(weapon)
		weapon_active.push_back(false)


func enter():
	finished = false
	
	for i in range(0, weapons.size()):
		if weapon_active[i]:
			weapons[i].attack()
			return
	
	finished = true


# Clean up the state. Reinitialize values like a timer
func exit():
	for i in range(0, weapon_active.size()):
		weapon_active[i] = false
	for weapon in weapons:
		weapon.stop_attack()
	
	host.get_node("BodyPivot").rotation_degrees = 0
	host.get_node("WeaponPivot").rotation_degrees = 0
	host.get_node("WeaponPivot").scale = Vector2(host.look_direction.x, 1)
	
	velocity = Vector2()
	host.STATES[IDLE].velocity = velocity


func handle_input(event):
	if event.is_action_pressed("primary_attack") and weapon_active[inputs.primary_weapon]:
		weapons[inputs.primary_weapon].register_attack()
	elif event.is_action_pressed("secondary_attack") and weapon_active[inputs.secondary_weapon]:
		weapons[inputs.secondary_weapon].register_attack()
	elif event.is_action_pressed("skill_1") and weapon_active[inputs.skill_1]:
		weapons[inputs.skill_1].register_attack()
	elif event.is_action_pressed("skill_2") and weapon_active[inputs.skill_2]:
		weapons[inputs.skill_2].register_attack()
	elif event.is_action_pressed("skill_3") and weapon_active[inputs.skill_3]:
		weapons[inputs.skill_3].register_attack()
	elif event.is_action_pressed("skill_4") and weapon_active[inputs.skill_4]:
		weapons[inputs.skill_4].register_attack()


func update(delta):
	if finished:
		return host.STATE_IDS.PREVIOUS_STATE
	
	# Move if carrying momentum
	steering(0, 35)
	move()


func _on_Weapon_attack_started():
	finished = false
	var angle = _rotate()
	_attack(angle)


func _rotate():
	var angle = 0
	var vector = Vector2()
	if host.target:
		vector = host.target.global_position - host.global_position
	else:
		vector = get_input_direction()
	
	move() # Get the correct direction to face
	
	if vector:
		angle = rad2deg(vector.angle())
	else:
		angle = 90 - 90 * host.look_direction.x
	if host.look_direction.x == -1:
		angle -= 180
		host.get_node("WeaponPivot").scale = Vector2(-1, -1)
	host.get_node("BodyPivot").rotation_degrees = angle
	host.get_node("WeaponPivot").rotation_degrees = angle
	
	return angle


func _attack(angle):
	var current_weapon
	for i in range(0, weapon_active.size()):
		if weapon_active[i]:
			current_weapon = weapons[i]
			break
	
	var attack_current = Attacks.attacks[current_weapon.attack_current]
	if attack_current.has("move_force"):
		velocity = attack_current.move_force * Vector2(sign(host.look_direction.x), 0).rotated(deg2rad(angle))
	if attack_current.has("host_animation"):
		host.Anim.play(attack_current.host_animation)
	
	# Skill
	if weapon_active[inputs.skill_1]:
		emit_signal("skill_used", 1, weapons[inputs.skill_1].cooldown)
	if weapon_active[inputs.skill_2]:
		emit_signal("skill_used", 2, weapons[inputs.skill_2].cooldown)
	if weapon_active[inputs.skill_3]:
		emit_signal("skill_used", 3, weapons[inputs.skill_3].cooldown)
	if weapon_active[inputs.skill_4]:
		emit_signal("skill_used", 4, weapons[inputs.skill_4].cooldown)


func _on_Weapon_attack_finished():
	finished = true


func _on_Weapon_attack_failed():
	finished = true


func activate_weapon(weapon):
	match weapon:
		"primary_attack":
			weapon_active[inputs.primary_weapon] = true
		"secondary_attack":
			weapon_active[inputs.secondary_weapon] = true
		"skill_1":
			weapon_active[inputs.skill_1] = true
		"skill_2":
			weapon_active[inputs.skill_2] = true
		"skill_3":
			weapon_active[inputs.skill_3] = true
		"skill_4":
			weapon_active[inputs.skill_4] = true


func _on_successful_hit(attack_name):
	var mana_gain = Attacks.attacks[attack_name].mana_gain
	host.get_node("Mana").recover_mana(mana_gain)
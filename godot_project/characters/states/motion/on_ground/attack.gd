extends 'on_ground.gd'

var finished = false

var weapons = []
var weapon_active = []
export(Array) var weapon_paths

var primary_weapon = 0
var secondary_weapon = 1
var skill_1 = 2
var skill_2 = 3
var skill_3 = 4
var skill_4 = 5


func setup(host):
	for weapon_path in weapon_paths:
		var weapon = load(weapon_path).instance()
		weapon.setup(host)
		weapon.connect("attack_started", self, "_on_Weapon_attack_started")
		weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
		host.get_node("WeaponPivot").add_child(weapon)
		weapons.push_back(weapon)
		weapon_active.push_back(false)


func _ready():
	pass


func enter(host):
	finished = false
	
	var current_weapon
	for i in range(0, weapons.size()):
		if weapon_active[i]:
			current_weapon = weapons[i]
	
	current_weapon.attack()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	for i in range(0, weapon_active.size()):
		weapon_active[i] = false
	for weapon in weapons:
		weapon.stop_attack()
	
	host.get_node("BodyPivot").rotation_degrees = 0
	host.get_node("WeaponPivot").rotation_degrees = 0
	host.get_node("WeaponPivot").scale = Vector2(host.look_direction.x, 1)
	
	velocity = Vector2()
	host.STATES[IDLE].velocity = velocity


func handle_input(host, event):
	if not host.is_player:
		return
	
	if event.is_action_pressed("primary_attack") and weapon_active[primary_weapon]:
		weapons[primary_weapon].register_attack()
	elif event.is_action_pressed("secondary_attack") and weapon_active[secondary_weapon]:
		weapons[secondary_weapon].register_attack()
	elif event.is_action_pressed("skill_1") and weapon_active[skill_1]:
		weapons[skill_1].register_attack()
	elif event.is_action_pressed("skill_2") and weapon_active[skill_2]:
		weapons[skill_2].register_attack()
	elif event.is_action_pressed("skill_3") and weapon_active[skill_3]:
		weapons[skill_3].register_attack()
	elif event.is_action_pressed("skill_4") and weapon_active[skill_4]:
		weapons[skill_4].register_attack()


func update(host, delta):
	if finished:
		return IDLE
	
	# Move if carrying momentum
	steering(host, 0, 35)
	move(host)


func _on_Weapon_attack_started(host):
	finished = false
	
	var angle = 0
	var vector = Vector2()
	if host.target:
		vector = host.target.global_position - host.global_position
	else:
		vector = get_input_direction(host)
	
	move(host) # Get the correct direction to face
	
	if vector:
		angle = rad2deg(vector.angle())
	else:
		angle = 90 - 90 * host.look_direction.x
	if host.look_direction.x == -1: # host is facing left, requires input_direction so default doesn't face right
		angle -= 180
		host.get_node("WeaponPivot").scale = Vector2(-1, -1)
	host.get_node("BodyPivot").rotation_degrees = angle
	host.get_node("WeaponPivot").rotation_degrees = angle
	
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


func _on_Weapon_attack_finished():
	finished = true


func attack():
	pass


func activate_weapon(weapon):
	match weapon:
		"primary_attack":
			weapon_active[primary_weapon] = true
		"secondary_attack":
			weapon_active[secondary_weapon] = true
		"skill_1":
			weapon_active[skill_1] = true
		"skill_2":
			weapon_active[skill_2] = true
		"skill_3":
			weapon_active[skill_3] = true
		"skill_4":
			weapon_active[skill_4] = true
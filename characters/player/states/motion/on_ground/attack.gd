extends 'on_ground.gd'

var finished = false
var primary_weapon_active = false
var secondary_weapon_active = false
var special_weapon_active = false

var primary_weapon = null
var secondary_weapon = null
var special_weapon = null
export(String) var primary_weapon_path = ""
export(String) var secondary_weapon_path = ""
export(String) var special_weapon_path = ""


func setup(host):
	if primary_weapon_path:
		primary_weapon = load(primary_weapon_path).instance()
		primary_weapon.setup(host)
		primary_weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
		primary_weapon.connect("attack_started", self, "_on_Weapon_attack_started")
		host.get_node("WeaponPivot").get_node("PrimaryWeaponSpawn").add_child(primary_weapon)
	if secondary_weapon_path:
		secondary_weapon = load(secondary_weapon_path).instance()
		secondary_weapon.setup(host)
		secondary_weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
		secondary_weapon.connect("attack_started", self, "_on_Weapon_attack_started")
		host.get_node("WeaponPivot").get_node("SecondaryWeaponSpawn").add_child(secondary_weapon)
	if special_weapon_path:
		special_weapon = load(special_weapon_path).instance()
		special_weapon.setup(host)
		special_weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
		special_weapon.connect("attack_started", self, "_on_Weapon_attack_started")
		host.get_node("WeaponPivot").get_node("SpecialWeaponSpawn").add_child(special_weapon)


func _ready():
	pass


func enter(host):
	finished = false
	
	var current_weapon
	if primary_weapon_active:
		current_weapon = primary_weapon
	elif secondary_weapon_active:
		current_weapon = secondary_weapon
	elif special_weapon_active:
		current_weapon = special_weapon
	
	current_weapon.attack()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	primary_weapon_active = false
	secondary_weapon_active = false
	special_weapon_active = false
	finished = false
	
	if primary_weapon:
		primary_weapon.stop_attack()
	if secondary_weapon:
		secondary_weapon.stop_attack()
	if special_weapon:
		special_weapon.stop_attack()
		
	host.get_node("BodyPivot").rotation_degrees = 0
	host.get_node("WeaponPivot").rotation_degrees = 0
	host.get_node("WeaponPivot").scale = Vector2(host.look_direction.x, 1)
	
	velocity = Vector2()
	host.STATES[IDLE].velocity = velocity


func handle_input(host, event):
	if event.is_action_pressed("primary_attack") and primary_weapon_active:
		primary_weapon.register_attack()
	elif event.is_action_pressed("secondary_attack") and secondary_weapon_active:
		secondary_weapon.register_attack()
	elif event.is_action_pressed("special_attack") and special_weapon_active:
		special_weapon.register_attack()


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
		vector = host.target_position - host.position
	else:
		vector = get_input_direction(host)
	angle = rad2deg(vector.angle())
	if sign(vector.x) == -1 or (host.look_direction.x == -1 and vector.x == 0): # host is facing left, requires input_direction so default doesn't face right
		angle -= 180
		host.get_node("WeaponPivot").scale = Vector2(-1, -1)
	host.get_node("BodyPivot").rotation_degrees = angle
	host.get_node("WeaponPivot").rotation_degrees = angle
	
	var current_weapon
	if primary_weapon_active:
		current_weapon = primary_weapon
	elif secondary_weapon_active:
		current_weapon = secondary_weapon
	elif special_weapon_active:
		current_weapon = special_weapon
	
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
			primary_weapon_active = true
		"secondary_attack":
			secondary_weapon_active = true
		"special_attack":
			special_weapon_active = true
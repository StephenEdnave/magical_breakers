extends 'motion.gd'

var primary_weapon = null
export(String) var primary_weapon_path = ""
var finished = false


func setup(host):
	if primary_weapon_path:
		primary_weapon = load(primary_weapon_path).instance()
		primary_weapon.setup(host)
		primary_weapon.connect("attack_started", self, "_on_Weapon_attack_started")
		primary_weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
		host.get_node("WeaponPivot").get_node("PrimaryWeaponSpawn").add_child(primary_weapon)


func enter(host):
	finished = false
	
	var current_weapon = primary_weapon
	current_weapon.attack()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("WeaponPivot").rotation_degrees = 0
	host.get_node("WeaponPivot").scale = Vector2(1, 1)
	
	primary_weapon.stop_attack()
	
	host.STATES[FOLLOW].velocity = velocity


func update(host, delta):
	if finished:
		return FOLLOW
	
	# Move if carrying momentum
	move(host)


func _on_Weapon_attack_started(host):
	finished = false
	
	var angle = 0
	var vector = Vector2()
	if host.has_target:
		vector = host.target_position - host.global_position
	angle = rad2deg(vector.angle())
	host.get_node("WeaponPivot").rotation_degrees = angle
	
	var current_weapon = primary_weapon
	var attack_current = Attacks.attacks[current_weapon.attack_current]
	if attack_current.has("move_force"):
		velocity = attack_current.move_force * Vector2(sign(host.look_direction.x), 0).rotated(deg2rad(angle))
	if attack_current.has("host_animation"):
		host.Anim.play(attack_current.host_animation)


func _on_Weapon_attack_finished():
	finished = true


func attack():
	pass
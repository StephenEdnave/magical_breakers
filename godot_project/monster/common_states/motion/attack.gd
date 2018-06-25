extends 'motion.gd'

export (String) var primary_weapon_path = ""
var primary_weapon = null

var finished = false


func _ready():
	if primary_weapon_path:
		primary_weapon = load(primary_weapon_path).instance()
		primary_weapon.connect("attack_started", self, "_on_Weapon_attack_started")
		primary_weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
		owner.get_node("WeaponPivot").get_node("PrimaryWeaponSpawn").add_child(primary_weapon)
		primary_weapon.setup(owner)


func enter():
	finished = false
	
	var current_weapon = primary_weapon
	if current_weapon:
		current_weapon.attack()
		return
	
	finished = true


# Clean up the state. Reinitialize values like a timer
func exit():
	owner.get_node("WeaponPivot").rotation_degrees = 0
	owner.get_node("WeaponPivot").scale = Vector2(1, 1)
	
	primary_weapon.stop_attack()
	
	owner.STATES[owner.STATE_IDS.FOLLOW].velocity = velocity


func update(delta):
	if finished:
		return owner.STATE_IDS.PREVIOUS_STATE
	
	# Move if carrying momentum
	move()


func _on_Weapon_attack_started():
	finished = false
	
	var angle = 0
	var vector = Vector2()
	if owner.has_target:
		vector = owner.target_position - owner.global_position
	angle = rad2deg(vector.angle())
	owner.get_node("WeaponPivot").rotation_degrees = angle
	
	var current_weapon = primary_weapon
	var attack_current = Attacks.attacks[current_weapon.attack_current]
	if attack_current.has("move_force"):
		velocity = attack_current.move_force * Vector2(sign(owner.look_direction.x), 0).rotated(deg2rad(angle))
	if attack_current.has("owner_animation"):
		owner.Anim.play(attack_current.owner_animation)


func _on_Weapon_attack_finished():
	finished = true


func attack():
	pass
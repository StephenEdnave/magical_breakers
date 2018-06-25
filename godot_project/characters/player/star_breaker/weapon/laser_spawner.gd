extends "res://utils/weapon.gd"



const Projectile = preload("LaserDrone.tscn")

var max_combo_count = 1
var weapon_combo = ["star_b_laser_spawn"]
var weapon_costs = [30]


func _ready():
	MAX_COMBO_COUNT = max_combo_count
	combo = weapon_combo
	costs = weapon_costs


func _enter_state(new_state):
	._enter_state(new_state)
	match state:
		ATTACK:
			spawn()


func _physics_process(delta):
	._update(delta)


func spawn():
	var spawn = $Pivot/Spawn1
	var projectile = Projectile.instance()
	owner.get_parent().add_child(projectile)
	projectile.clockwise = true
	projectile.global_position = spawn.global_position
	projectile.scale = owner.scale
	projectile.set_direction(Vector2(cos(deg2rad(spawn.global_rotation_degrees)), sin(deg2rad(spawn.global_rotation_degrees))).normalized())
	projectile.connect("successful_hit", self, "successful_hit")
	
	spawn = $Pivot/Spawn2
	projectile = Projectile.instance()
	owner.get_parent().add_child(projectile)
	projectile.clockwise = false
	projectile.global_position = spawn.global_position
	projectile.scale = owner.scale
	projectile.set_direction(Vector2(cos(deg2rad(spawn.global_rotation_degrees)), sin(deg2rad(spawn.global_rotation_degrees))).normalized())
	projectile.connect("successful_hit", self, "successful_hit")
extends "res://utils/weapon.gd"


const Projectile = preload("Projectile.tscn")

var max_combo_count = 1
var weapon_combo = ["basic_plushy_gun"]
var weapon_costs = [0]


func _ready():
	MAX_COMBO_COUNT = max_combo_count
	combo = weapon_combo
	costs = weapon_costs


func _enter_state(new_state):
	._enter_state(new_state)
	match new_state:
		ATTACK:
			spawn()


func _physics_process(delta):
	._update(delta)


func spawn():
	var projectile = Projectile.instance()
	get_tree().get_root().add_child(projectile)
	projectile.position = $Pivot/Spawn.global_position
	projectile.scale = owner.scale
	var angle = deg2rad($Pivot/Spawn.global_rotation_degrees)
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	projectile.set_direction(direction)
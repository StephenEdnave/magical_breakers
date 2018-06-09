extends "res://characters/weapon/weapon.gd"


const Projectile = preload("StickyBomb.tscn")

var max_combo_count = 1
var weapon_combo = ["star_b_sticky_bomb_launch"]
var weapon_costs = [0]


func setup(_host):
	.setup(_host)


func _ready():
	MAX_COMBO_COUNT = max_combo_count
	combo = weapon_combo
	costs = weapon_costs


func _change_state(new_state):
	._change_state(new_state)


func _exit_state(old_state):
	._exit_state(old_state)


func _enter_state(new_state):
	._enter_state(new_state)
	match new_state:
		ATTACK:
			spawn()


func _physics_process(delta):
	._update(delta)


func spawn():
	for spawn in $Pivot.get_children():
		var projectile = Projectile.instance()
		host.get_parent().add_child(projectile)
		projectile.global_position = spawn.global_position
		projectile.scale = host.scale
		projectile.set_direction(Vector2(cos(deg2rad(spawn.global_rotation_degrees)), sin(deg2rad(spawn.global_rotation_degrees))).normalized())
		projectile.set_target(host.target_position)
		projectile.connect("successful_hit", self, "successful_hit")
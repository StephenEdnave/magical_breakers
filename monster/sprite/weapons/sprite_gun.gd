extends "res://characters/weapon/weapon.gd"


const Projectile = preload("SpriteProjectile.tscn")

var max_combo_count = 3
var weapon_combo = ["sprite_gun",
	"sprite_gun",
	"sprite_gun",]


var max_angle = 25


func setup(_host):
	.setup(_host)


func _ready():
	MAX_COMBO_COUNT = max_combo_count
	combo = weapon_combo


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
	var projectile = Projectile.instance()
	get_tree().get_root().add_child(projectile)
	projectile.position = $Pivot/Spawn.global_position
	projectile.scale = host.scale
	var angle = deg2rad($Pivot/Spawn.global_rotation_degrees)
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	projectile.set_direction(direction)
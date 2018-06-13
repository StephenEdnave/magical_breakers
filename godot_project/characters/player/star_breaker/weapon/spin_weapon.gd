extends "res://utils/weapon.gd"


var max_combo_count = 4
var weapon_combo = ["star_b_melee_1", "star_b_melee_2", "star_b_melee_3", "star_b_melee_4"]
var weapon_costs = [0, 0, 0, 0]


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


func _physics_process(delta):
	if ._update(delta) == false:
		return
	
	for body in get_overlapping_bodies():
		if body.get_rid().get_id() in hit_objects:
			continue
		hit_objects.append(body.get_rid().get_id())
		var body_is_parent = body.take_damage(self, attack_current)
		if not body_is_parent:
			successful_hit(attack_current)
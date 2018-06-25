extends 'res://monster/common_states/motion/attack.gd'

export (String) var first_plushy_path = ""
var first_plushy = null
export (String) var second_plushy_path = ""
var second_plushy = null


func enter():
	finished = false
	
	match owner.spawned_monsters:
		0:
			if first_plushy_path:
				owner.Anim.play("spawn_plushy")
				first_plushy = load(first_plushy_path).instance()
				first_plushy.connect("died", owner, "_on_plushy_died", [1])
				owner.get_parent().add_child(first_plushy)
				first_plushy.global_position = owner.global_position
				owner.spawned_monsters += 1
		1:
			if second_plushy_path:
				owner.Anim.play("spawn_plushy")
				second_plushy = load(second_plushy_path).instance()
				second_plushy.connect("died", owner, "_on_plushy_died", [2])
				owner.get_parent().add_child(second_plushy)
				second_plushy.global_position = owner.global_position
				owner.spawned_monsters += 1
		_:
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


func _on_animation_finished(name):
	return owner.STATE_IDS.PREVIOUS_STATE
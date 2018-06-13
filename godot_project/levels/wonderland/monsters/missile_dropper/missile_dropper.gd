extends "res://monster/monster.gd"

signal state_changed

enum STATE_IDS { IDLE, ROAM, RETURN, SPOT, FOLLOW, STAGGER, DIE, DEAD, SHOOT, END_PHASE}
onready var STATES = {
	IDLE:$'States/Idle',
	ROAM:$'States/Roam',
	RETURN:$'States/Return',
	SPOT:$'States/Spot',
	FOLLOW:$'States/Follow',
	STAGGER:$'States/Stagger',
	DIE:$'States/Die',
	SHOOT:$'States/Shoot',
	END_PHASE:$'States/EndPhase'
#	DEAD:$'States/Dead'
}


func _ready():
	current_state = STATES[IDLE]
	current_state.enter()


func _physics_process(delta):
	var new_state = current_state.update(delta)
	if new_state or new_state == 0:
		go_to_state(new_state)


# Exit the current state, change it and enter the new one
func go_to_state(state_id):
	current_state.exit()
	var new_state = STATES[state_id]
	new_state.enter()
	current_state = new_state
	emit_signal('state_changed', new_state)


func _on_animation_finished(name):
	if not current_state.has_method("_on_animation_finished"):
		return
	var new_state = current_state._on_animation_finished(name)
	if new_state or new_state == 0:
		go_to_state(new_state)


func take_damage(source, attack_name):
	if self.is_a_parent_of(source):
		return
	var knockback_direction = (global_position - source.global_position).normalized()
#	STATES[STAGGER].setup(knockback_direction, Attacks.attacks[attack_name].knockback_force, Attacks.attacks[attack_name].knockback_duration)
	.take_damage(source, attack_name)


func _on_Health_health_changed(new_health, knockback):
	if new_health == 0:
		go_to_state(DIE)
#	else:
#		if knockback == true:
#			go_to_state(STAGGER)
	._on_Health_health_changed(new_health, knockback)


func end_phase():
	go_to_state(END_PHASE)


#func died():
#	pass
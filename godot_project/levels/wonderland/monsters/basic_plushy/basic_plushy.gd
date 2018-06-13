extends "res://monster/monster.gd"

signal state_changed

enum STATE_IDS { IDLE, ROAM, RETURN, SPOT, FOLLOW, STAGGER, DIE, ATTACK, END_PHASE, DEAD, PREVIOUS_STATE }
onready var STATES = {
	IDLE:$'States/Idle',
	ROAM:$'States/Roam',
	RETURN:$'States/Return',
	SPOT:$'States/Spot',
	FOLLOW:$'States/Follow',
	STAGGER:$'States/Stagger',
	DIE:$'States/Die',
	ATTACK:$'States/Attack',
	END_PHASE:$'States/EndPhase',
	DEAD:$'States/Dead'
}


func _ready():
	states_stack.push_front(STATES[IDLE])
	states_stack[0].enter()


func _physics_process(delta):
	var new_state = states_stack[0].update(delta)
	if new_state or new_state == 0:
		go_to_state(new_state)


# Exit the current state, change it and enter the new one
func go_to_state(new_state):
	states_stack[0].exit()
	
	match new_state:
		PREVIOUS_STATE:
			states_stack.pop_front()
		ATTACK, STAGGER:
			states_stack.push_front(STATES[new_state])
		_:
			states_stack[0] = STATES[new_state]
	states_stack[0].enter()
	emit_signal('state_changed', states_stack[0])


func _on_animation_finished(name):
	var new_state = states_stack[0]._on_animation_finished(name)
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
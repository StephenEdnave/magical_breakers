extends '../monster.gd'

signal state_changed

enum STATE_IDS { IDLE, ROAM, RETURN, SPOT, FOLLOW, STAGGER, CHARGE_PREPARE, CHARGE, CHARGE_COOLDOWN, DIE, DEAD, SHOOT}
onready var STATES = {
	IDLE:$'States/Idle',
	ROAM:$'States/Roam',
	RETURN:$'States/Return',
	SPOT:$'States/Spot',
	FOLLOW:$'States/Follow',
	STAGGER:$'States/Stagger',
	CHARGE_PREPARE:$'States/ChargePrepare',
	CHARGE:$'States/Charge',
	CHARGE_COOLDOWN:$'States/ChargeCooldown',
	DIE:$'States/Die',
	SHOOT:$'States/Shoot',
#	DEAD:$'States/Dead'
}

export(float) var SPOT_RANGE = 320.0


func _ready():
	STATES[IDLE].setup(self, SPOT_RANGE)
	STATES[ROAM].setup(SPOT_RANGE)
	STATES[RETURN].setup(SPOT_RANGE, ARRIVE_DISTANCE)
	STATES[SPOT].setup(SPOT_RANGE)
	STATES[SHOOT].setup(self)
	
	current_state = STATES[IDLE]
	current_state.enter(self)


func _physics_process(delta):
	var new_state = current_state.update(self, delta)
	if new_state or new_state == 0:
		go_to_state(new_state)


# Exit the current state, change it and enter the new one
func go_to_state(state_id):
	current_state.exit(self)
	var new_state = STATES[state_id]
	new_state.enter(self)
	current_state = new_state
	emit_signal('state_changed', new_state)


func _on_animation_finished(name):
	if not current_state.has_method("_on_animation_finished"):
		return
	var new_state = current_state._on_animation_finished(self, name)
	if new_state or new_state == 0:
		go_to_state(new_state)


func take_damage(source, attack_name):
	if self.is_a_parent_of(source):
		return
	var knockback_direction = (global_position - source.global_position).normalized()
#	STATES[STAGGER].setup(knockback_direction, Attacks.attacks[attack_name].knockback_force, Attacks.attacks[attack_name].knockback_duration)
	$Stagger.play("stagger")
	.take_damage(source, attack_name)


func _on_Health_health_changed(new_health, knockback):
	if new_health == 0:
		go_to_state(DIE)
#	else:
#		if knockback == true:
#			go_to_state(STAGGER)
	._on_Health_health_changed(new_health, knockback)
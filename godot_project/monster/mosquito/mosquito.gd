extends '../monster.gd'

signal state_changed

enum STATES { IDLE, FOLLOW, RETURN, DIE }
onready var STATES = {
	IDLE:$'States/Idle',
	RETURN:$'States/Return',
	FOLLOW:$'States/Follow',
	DIE:$'States/Die',
}

func _ready():
	current_state = STATES[IDLE]
	current_state.enter(self)
	Anim.connect('animation_finished', self, '_on_animation_finished')


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


func take_damage(source, amount, effect, damage_type, knockback_force):
	if self.is_a_parent_of(source):
		return
	var knockback_direction = (global_position - source.global_position).normalized()
	.take_damage(source, amount, effect, damage_type, knockback_force)


func _on_Health_health_changed(new_health, knockback):
	if new_health == 0:
		go_to_state(DIE)
	._on_Health_health_changed(new_health, knockback)
extends KinematicBody2D

signal state_changed
signal direction_changed
signal health_changed
signal mana_changed
signal position_changed
signal died

enum STATE_IDS { IDLE, WALK, DASH, ATTACK, DIE, DEAD, STAGGER, PREVIOUS_STATE }
# Don't forget the onready keyword: we can only get the State nodes
# after they were added to the scene tree
onready var STATES = {
	IDLE:$'States/Idle',
	WALK:$'States/Walk',
	DASH:$'States/Dash',
	ATTACK:$'States/Attack',
	DIE:$'States/Die',
	DEAD:$'States/Dead',
	STAGGER:$'States/Stagger'
}
var states_stack = []

onready var Anim = $AnimationPlayer
onready var Tween = $Tween

var look_direction = Vector2(1, 0)

var is_player = false

func _ready():
	$AnimationPlayer.play("SETUP")
	states_stack.push_front(STATES[IDLE])
	states_stack[0].enter()
	$Health.connect("health_changed", self, "_on_Health_health_changed")
	$Health.connect("status_changed", self, "_on_Health_status_changed")
	$Mana.connect("mana_changed", self, "_on_Mana_changed")
	$Mana.connect("status_changed", self, "_on_Mana_status_changed")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")


func _physics_process(delta):
	var new_state = states_stack[0].update(delta)
	if new_state or new_state == 0:
		go_to_state(new_state)


func _input(event):
	var new_state = states_stack[0].handle_input(event)
	if new_state or new_state == 0:
		go_to_state(new_state)


# Exit the current state, change it and enter the new one
func go_to_state(new_state):
	states_stack[0].exit()
	
	match new_state:
#		PREVIOUS_STATE:
#			states_stack.pop_front()
#		ATTACK, STAGGER:
#			states_stack.push_front(STATES[new_state])
		_:
			states_stack[0] = STATES[new_state]
	states_stack[0].enter()
	emit_signal('state_changed', states_stack[0])


func take_damage(source, attack_name):
	if self.is_a_parent_of(source):
		return true # Return if parent
	var knockback_direction = (global_position - source.global_position).normalized()
	STATES[STAGGER].setup(knockback_direction, attack_name)
	$Health.take_damage(attack_name)


func _on_Health_health_changed(new_health, knockback):
	emit_signal("health_changed", new_health)
	if new_health == 0:
		go_to_state(DIE)
	else:
		if knockback == true:
			go_to_state(STAGGER)


func _on_Health_status_changed(new_status):
	$StatusPivot/StatusIcon.change_status(new_status)


func _on_Mana_changed(new_mana):
	emit_signal("mana_changed", new_mana)


func _on_Mana_status_changed(new_status):
	pass


func _on_animation_finished(name):
	var new_state = states_stack[0]._on_animation_finished(name)
	if new_state or new_state == 0:
		go_to_state(new_state)


func position_changed():
	emit_signal("position_changed", global_position)
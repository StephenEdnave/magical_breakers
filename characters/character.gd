extends KinematicBody2D

signal state_changed
signal direction_changed
signal health_changed
signal position_changed
signal died

enum STATE_IDS { IDLE, WALK, DASH, ATTACK, DIE, DEAD, STAGGER }
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
var current_state = null

onready var Anim = $AnimationPlayer
onready var Tween = $Tween

var look_direction = Vector2(1, 0)

var is_player = false

func _ready():
	$AnimationPlayer.play("SETUP")
	current_state = STATES[IDLE]
	current_state.enter(self)
	$Health.connect("health_changed", self, "_on_Health_health_changed")
	$Health.connect("status_changed", self, "_on_Health_status_changed")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	STATES[ATTACK].setup(self)


func _physics_process(delta):
	var new_state = current_state.update(self, delta)
	if new_state or new_state == 0:
		go_to_state(new_state)


func _input(event):
	var new_state = current_state.handle_input(self, event)
	if new_state or new_state == 0:
		go_to_state(new_state)


# Exit the current state, change it and enter the new one
func go_to_state(state_id):
	current_state.exit(self)
	var new_state = STATES[state_id]
	new_state.enter(self)
	current_state = new_state
	emit_signal('state_changed', new_state)


func take_damage(source, attack_name):
	if self.is_a_parent_of(source):
		return
	var knockback_direction = (global_position - source.global_position).normalized()
	STATES[STAGGER].setup(knockback_direction, Attacks.attacks[attack_name].knockback_force, Attacks.attacks[attack_name].knockback_duration)
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


func _on_animation_finished(name):
	if not current_state.has_method("_on_animation_finished"):
		return
	var new_state = current_state._on_animation_finished(self, name)
	if new_state or new_state == 0:
		go_to_state(new_state)


func position_changed():
	emit_signal("position_changed", global_position)
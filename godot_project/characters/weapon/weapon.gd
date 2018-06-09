extends Area2D

signal attack_started
signal attack_finished
signal attack_failed
signal successful_hit

var state = null
enum STATES {IDLE, ATTACK}

enum ATTACK_INPUT_STATES { IDLE, LISTENING, REGISTERED }
var attack_input_state = IDLE
var ready_for_next_attack = false

var MAX_COMBO_COUNT = 1
var combo_count = 0

var host = null

var hit_objects = []

var combo = ["SETUP"]
var attack_current = ""
var costs = []

export (float) var cooldown = 0.01
var CooldownTimer = null


func setup(_host):
	host = _host


func _ready():
	CooldownTimer = Timer.new()
	add_child(CooldownTimer)
	CooldownTimer.wait_time = cooldown
	CooldownTimer.one_shot = true
	
	$AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	$AnimationPlayer.play("SETUP")
	_change_state(IDLE)


func _change_state(new_state):
	_exit_state(state)
	_enter_state(new_state)


func _exit_state(old_state):
	match old_state:
		ATTACK:
			hit_objects = []
			attack_input_state = IDLE
			ready_for_next_attack = false


func _enter_state(new_state):
	match new_state:
		IDLE:
			combo_count = 0
			monitoring = false
			$AnimationPlayer.play("idle")
		ATTACK:
			if not CooldownTimer.is_stopped():
				emit_signal("attack_failed")
				return
			if host.has_node("Mana"):
				if host.get_node("Mana").mana < costs[combo_count - 1]:
					if not state == ATTACK: # If currently attacking, let animation finish, otherwise return
						emit_signal("attack_failed")
						return
				else:
					host.get_node("Mana").expend_mana(costs[combo_count - 1])
			monitoring = true
			attack_current = combo[combo_count - 1]
			$AnimationPlayer.play(Attacks.attacks[attack_current].animation)
			emit_signal("attack_started", host)
			CooldownTimer.start()
	state = new_state


func _update(delta): # Return boolean values in case derived classes need to break during an _update call
	if attack_input_state == REGISTERED and ready_for_next_attack and combo_count < MAX_COMBO_COUNT:
		attack()
		return false
	
	if not state == ATTACK:
		return false
	
	return true


func register_attack():
	if attack_input_state != LISTENING:
		return
	attack_input_state = REGISTERED


func attack():
	if combo_count < MAX_COMBO_COUNT:
		combo_count += 1
		_change_state(ATTACK)


func set_attack_input_listening():
	attack_input_state = LISTENING


func set_ready_for_next_attack():
	ready_for_next_attack = true


func stop_attack():
	_change_state(IDLE)


func _on_AnimationPlayer_animation_finished(name):
	if name == "idle" or state == IDLE:
		return
	
	_change_state(IDLE)
	emit_signal("attack_finished")


func successful_hit(attack_name):
	emit_signal("successful_hit", attack_name)
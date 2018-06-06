# Base class all states inherit from
# Stores a ref to the Player node, and the STATE_IDS
extends Node

enum STATES { IDLE, ROAM, RETURN, SPOT, FOLLOW, STAGGER, CHARGE_PREPARE, CHARGE, CHARGE_COOLDOWN, DIE, DEAD, SHOOT, END_PHASE}


func _ready():
	# In 3.0 alpha, these functions are on by default for every node
	set_process(false)
	set_physics_process(false)
	set_process_input(false)


# Initialize the state. E.g. change the animation
func enter(host):
	pass


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	pass
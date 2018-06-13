# Base class all states inherit from
# Stores a ref to the Player node, and the STATE_IDS
extends Node

enum STATES { IDLE, WALK, DASH, ATTACK, DIE, DEAD, STAGGER }
var host = null


func _ready():
	# Store a reference to the FSM
	host = $'../..'

	# In 3.0 alpha, these functions are on by default for every node
	set_process(false)
	set_physics_process(false)
	set_process_input(false)


# Initialize the state. E.g. change the animation
func enter():
	pass


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func handle_input(event):
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	return
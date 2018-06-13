# Base class all states inherit from
# Stores a ref to the Player node, and the STATE_IDS
extends Node

var host = null

func _ready():
	host = $'../..'
	
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
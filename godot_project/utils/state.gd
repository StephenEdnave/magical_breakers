"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

signal finished

# A reference to the character or entity the states control
var host = null

func _ready():
	host = $'../..' # A state is typically held in a node-path such as "host/States/State"

# Initialize the state. E.g. change the animation
func enter():
	return


# Clean up the state. Reinitialize values like a timer
func exit():
	return


func update(delta):
	return


func _on_animation_finished(anim_name):
	return
extends "res://utils/state.gd"

export (float) var SPOT_RANGE = 3000.0
var start_roaming = false

func _ready():
	host.get_node("RoamTimer").connect("timeout", self, "_on_RoamTimer_timeout")


# Initialize the state. E.g. change the animation
func enter():
	start_roaming = false
	host.Anim.play("idle")
	randomize()
	host.get_node("RoamTimer").wait_time = randf() * 2 + 1.0
	host.get_node("RoamTimer").start()


# Clean up the state. Reinitialize values like a timer
func exit():
	host.get_node("RoamTimer").stop()
	start_roaming = false


func update(delta):
	if host.global_position.distance_to(host.target_position) < SPOT_RANGE:
		if not host.has_target:
			return
		return host.STATE_IDS.SPOT
	
	if start_roaming:
		return host.STATE_IDS.ROAM


func _on_RoamTimer_timeout():
	start_roaming = true
extends 'state.gd'

var SPOT_RANGE = 320.0
var start_roaming = false

func setup(host, _spot_range):
	SPOT_RANGE = _spot_range
	host.get_node("RoamTimer").connect("timeout", self, "_on_RoamTimer_timeout")


# Initialize the state. E.g. change the animation
func enter(host):
	start_roaming = false
	host.Anim.play("idle")
	randomize()
	host.get_node("RoamTimer").wait_time = randf() * 2 + 1.0
	host.get_node("RoamTimer").start()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("RoamTimer").stop()
	start_roaming = false


func handle_input(host, event):
	pass


func update(host, delta):
	if host.position.distance_to(host.target_position) < SPOT_RANGE:
		if not host.has_target:
			return
		return SPOT
	
	if start_roaming:
		return ROAM


func _on_RoamTimer_timeout():
	start_roaming = true
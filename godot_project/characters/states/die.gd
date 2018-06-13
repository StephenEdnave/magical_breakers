extends 'state.gd'

var died = false

func enter():
#	host.set_process_input(false) # Stops input so player/AI can't control entity
	host.get_node("CollisionShape2D").disabled = true
	host.Anim.play("die")
	host.remove_from_group("characters")
	host.emit_signal("died")
	died = false


func exit():
	pass


func handle_input(event):
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	assert name == "die"
	return host.STATE_IDS.DEAD
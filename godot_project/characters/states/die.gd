extends '_state.gd'

var died = false

func enter(host):
#	host.set_process_input(false) # Stops input so player/AI can't control entity
	host.get_node("CollisionShape2D").disabled = true
	host.Anim.play("die")
	host.remove_from_group("characters")
	host.emit_signal("died")
	died = false


func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	if died:
		return DEAD


func _on_animation_finished(host, name):
	died = true
extends 'state.gd'

func enter(host):
	host.set_process_input(false) # Stops input so player/AI can't control entity
	host.get_node("CollisionPolygon2D").disabled = true
	host.Anim.play("die")


func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	pass


func _on_animation_finished(host, name):
	host.die()
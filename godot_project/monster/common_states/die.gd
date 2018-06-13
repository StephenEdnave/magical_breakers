extends "res://utils/state.gd"


func enter():
	if host.is_in_group("monsters"):
		host.remove_from_group("monsters")
	host.emit_signal("died")
	host.get_node("CollisionShape2D").disabled = true
	host.get_node("CollisionPolygon2D").disabled = true
	host.Anim.play("die")
	host.set_process_input(false) # Stops input so player/AI can't control entity


func exit():
	pass


func handle_input(event):
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	assert name == "die"
	return host.STATE_IDS.DEAD
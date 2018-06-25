extends "res://utils/states/state.gd"


func enter():
	if owner.is_in_group("monsters"):
		owner.remove_from_group("monsters")
	owner.emit_signal("died")
	owner.get_node("CollisionShape2D").disabled = true
	owner.get_node("CollisionPolygon2D").disabled = true
	owner.Anim.play("die")
	owner.set_process_input(false) # Stops input so player/AI can't control entity


func exit():
	pass


func handle_input(event):
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	assert name == "die"
	return owner.STATE_IDS.DEAD
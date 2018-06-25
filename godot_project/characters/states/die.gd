extends 'state.gd'

var died = false

func enter():
#	owner.set_process_input(false) # Stops input so player/AI can't control entity
	owner.get_node("CollisionShape2D").disabled = true
	owner.Anim.play("die")
	owner.remove_from_group("characters")
	owner.emit_signal("died")
	died = false


func exit():
	pass


func handle_input(event):
	pass


func update(delta):
	pass


func _on_animation_finished(name):
	assert name == "die"
	return owner.STATE_IDS.DEAD
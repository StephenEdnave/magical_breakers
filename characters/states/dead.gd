extends '_state.gd'


func enter(host):
	host.remove_from_group("characters")
	host.emit_signal("died")


func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	pass
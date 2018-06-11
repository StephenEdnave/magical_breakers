extends Position2D

export (PackedScene) var object

func spawn(host):
	if not object:
		return
	
	var new_object = object.instance()
	host.add_child(new_object)
	new_object.global_position = global_position
	new_object.start_position = global_position
	return new_object
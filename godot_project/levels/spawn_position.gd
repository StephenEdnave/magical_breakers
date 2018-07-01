extends Position2D

export (String) var object_path = ""

func spawn(host):
	if not object_path:
		return
	
	var new_object = load(object_path).instance()
	host.add_child(new_object)
	new_object.global_position = global_position
	new_object.start_position = global_position
	return new_object
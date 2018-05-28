extends Line2D


var target = null
export (NodePath) var target_path = null
export (float) var trail_length = 10
var tracking = false
var removal_increment = 0
var removal_time = 2

func _ready():
	if not target_path:
		print("No target path at %s." %get_path())
		$TrailTimer.stop()
		return
	target = get_node(target_path)
	set_as_toplevel(true)


func reset():
	for i in points:
		remove_point(0)
	tracking = true

func _on_TrailTimer_timeout():
	if tracking:
		global_position = Vector2()
		global_rotation_degrees = 0
		add_point(target.global_position)
		if get_point_count() > trail_length:
			remove_point(0)
	else:
		if get_point_count() > 0:
			removal_increment += 1
			if removal_increment == removal_time:
				removal_increment = 0
				remove_point(0)


func stop_tracking():
	tracking = false
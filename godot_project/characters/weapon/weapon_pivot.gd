extends Position2D


func _ready():
	get_parent().connect("direction_changed", self, "_on_Parent_direction_changed")

func _on_Parent_direction_changed(direction):
	rotation = direction.angle()
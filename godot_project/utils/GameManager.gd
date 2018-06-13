extends Node

var player_character = "player"
var level_name = "level"

var window_size = Vector2()

func _ready():
	window_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
extends Node2D

var player = null
var player_max_health = 0

func _ready():
	player = $YSort/Player
	player.connect("health_changed", self, "_on_player_health_changed")
	player.connect("died", self, "_on_player_died")
	player_max_health = player.get_node("Health").max_health
	_on_player_health_changed(player.get_node("Health").health)


func _on_player_health_changed(health):
	$UI/HealthBar.value = float(health) / float(player_max_health) * 100


func _on_player_died():
	get_tree().create_timer(2.0).connect("timeout", self, "change_scene", ["res://main_menu/MainMenu.tscn"])


func change_scene(scene):
	$Music.stop()
	$Ambience.stop()
	$UI/Transitions.fade_in(scene)
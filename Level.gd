extends Node2D

var MainMenu = "res://main_menu/MainMenu.tscn"
var player = null
var player_max_health = 0

func _ready():
	player = $YSort/Player
	player.connect("health_changed", self, "_on_player_health_changed")
	player.connect("died", self, "_on_player_died")
	player_max_health = player.get_node("Health").max_health
	_on_player_health_changed(player.get_node("Health").health)
	_on_player_hyper_changed(100.0)
	$AnimationPlayer.play("level")


func _process(delta):
	$YSort.position
	$YSort/Player/Camera2D.limit_left = $YSort.position.x - 1000
	$YSort/Player/Camera2D.limit_top = $YSort.position.y - 600
	$YSort/Player/Camera2D.limit_right = $YSort.position.x + 1000
	$YSort/Player/Camera2D.limit_bottom = $YSort.position.x + 600


func _on_player_health_changed(health):
	$UI/Interface/Bars/HealthBar/TextureProgress.value = float(health) / float(player_max_health) * 100
	$UI/Interface/Bars/HealthBar/Counter/Label.text = str(float(health)) +" / " + str(float(player_max_health))


func _on_player_hyper_changed(hyper):
	var player_max_hyper = 100.0
	$UI/Interface/Bars/HyperBar/TextureProgress.value = float(hyper) / float(player_max_hyper) * 100
	$UI/Interface/Bars/HyperBar/Counter/Label.text = str(float(hyper)) +" / " + str(float(player_max_hyper))


func _on_player_died():
	get_tree().create_timer(2.0).connect("timeout", self, "change_scene", [MainMenu])


func change_scene(scene):
	$Music.stop()
	$Ambience.stop()
	$UI/Transitions.fade_in(scene)


func win():
	change_scene(MainMenu)
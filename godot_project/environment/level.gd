extends Node2D

enum STATES { NORMAL, GAME_OVER }
var current_state

var MainMenu = "res://menus/main_menu/MainMenu.tscn"
var WinMenu = "res://menus/win_menu/WinMenu.tscn"

var player = null
var player_max_health = 0

var current_wave = 0

func _ready():
	current_state = NORMAL
	
	player = $YSort/Player
	player.connect("health_changed", self, "_on_player_health_changed")
	player.connect("died", self, "_on_player_died")
	player_max_health = player.get_node("Health").max_health
	_on_player_health_changed(player.get_node("Health").health)
	_on_player_hyper_changed(100.0)
	
	$UI/AnimationPlayer.connect("animation_finished", self, "_on_ui_animation_finished")
	$UI/AnimationPlayer.play("SETUP")
	
	for wave in $YSort/Waves.get_children():
		wave.connect("wave_ended", self, "wave_ended")
	
	$YSort/Waves.get_child(current_wave).start_wave()


func _process(delta):
	var limit_left = $YSort.global_position.x
	var limit_right = $YSort.global_position.x + 2000
	var limit_top = $YSort.global_position.y
	var limit_bottom = $YSort.global_position.y + 1200
	$YSort/Player/Camera2D.limit_left = limit_left
	$YSort/Player/Camera2D.limit_top = limit_top
	$YSort/Player/Camera2D.limit_right = limit_right
	$YSort/Player/Camera2D.limit_bottom = limit_bottom
	
	player.global_position.x = clamp(player.global_position.x, limit_left, limit_right)
	player.global_position.y = clamp(player.global_position.y, limit_top, limit_bottom)
	


func _on_player_health_changed(health):
	$UI/Interface/Bars/HealthBar/TextureProgress.value = float(health) / float(player_max_health) * 100
	$UI/Interface/Bars/HealthBar/Counter/Label.text = str(float(health)) +" / " + str(float(player_max_health))


func _on_player_hyper_changed(hyper):
	var player_max_hyper = 100.0
	$UI/Interface/Bars/HyperBar/TextureProgress.value = float(hyper) / float(player_max_hyper) * 100
	$UI/Interface/Bars/HyperBar/Counter/Label.text = str(float(hyper)) +" / " + str(float(player_max_hyper))


func _on_player_died():
	current_state = GAME_OVER
	yield (get_tree().create_timer(2.0), "timeout")
	$UI/AnimationPlayer.play("exit")


func change_scene(scene):
	$Music.stop()
	$Ambience.stop()
	get_tree().change_scene(scene)


func win():
	$Tween.interpolate_property($Music, "volume_db", $Music.volume_db, -100.0, 3, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property(Engine, "time_scale", 0.5, 1, 2, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	player.set_process(false)
	yield(get_tree().create_timer(1), "timeout")
	Engine.time_scale = 1
	yield(get_tree().create_timer(5), "timeout")
	Engine.time_scale = 1
	$UI/AnimationPlayer.play("exit")


func wave_ended():
	current_wave += 1
	if current_wave >= $YSort/Waves.get_child_count():
		win()
	else:
		$YSort/Waves.get_child(current_wave).start_wave()


func _on_ui_animation_finished(name):
	match name:
		"SETUP":
			$UI/AnimationPlayer.play("enter")
		"exit":
			if current_state == NORMAL:
				change_scene(WinMenu)
			else:
				change_scene(MainMenu)
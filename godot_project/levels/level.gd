extends Node2D

signal cutscene_started
signal cutscene_finished

enum STATES { NORMAL, CUTSCENE, PLAYER_DIED, WIN }
var current_state

var MainMenu = "res://menus/main_menu/MainMenu.tscn"
var WinMenu = "res://menus/win_menu/WinMenu.tscn"

var player = null

var current_phase = 0

var camera = null
var extra_h_space = 500
var extra_v_space = 300

func _ready():
	current_state = NORMAL
	
	player = $YSort/Player
	player.connect("died", self, "_change_state", [PLAYER_DIED])
	$UI/Interface.setup(player)
	
	camera = $YSort/Player/Camera2D
	
	$UI/AnimationPlayer.connect("animation_finished", self, "_on_ui_animation_finished")
	$UI/AnimationPlayer.play("SETUP")
	
	for phase in $YSort/Phases.get_children():
		phase.connect("phase_ended", self, "phase_ended")
	
	$YSort/Phases.get_child(current_phase).start_phase()
	
	GameManager.level = self


func _process(delta):
	# Camera limits
	var limit_left = ($YSort.global_position.x - GameManager.window_size.x / 2)
	var limit_right = ($YSort.global_position.x + GameManager.window_size.x / 2) * camera.zoom.x + extra_h_space
	var limit_top = ($YSort.global_position.y - GameManager.window_size.y / 2)
	var limit_bottom = ($YSort.global_position.y  + GameManager.window_size.y / 2) * camera.zoom.y + extra_v_space
	camera.limit_left = limit_left
	camera.limit_top = limit_top
	camera.limit_right = limit_right
	camera.limit_bottom = limit_bottom
	
	# Bound player to screen
	player.global_position.x = clamp(player.global_position.x, limit_left, limit_right)
	player.global_position.y = clamp(player.global_position.y, limit_top, limit_bottom)


func _change_state(new_state):
	match current_state:
		CUTSCENE:
			emit_signal("cutscene_finished")
	
	match new_state:
		CUTSCENE:
			emit_signal("cutscene_started")
		PLAYER_DIED:
			yield (get_tree().create_timer(2.0), "timeout")
			$UI/AnimationPlayer.play("exit")
		WIN:
			$Tween.interpolate_property(Engine, "time_scale", 0.5, 1, 2, Tween.TRANS_QUAD, Tween.EASE_IN)
			$Tween.start()
			player.set_process(false)
			yield(get_tree().create_timer(1), "timeout")
			Engine.time_scale = 1
			yield(get_tree().create_timer(5), "timeout")
			$Tween.interpolate_property($Music, "volume_db", $Music.volume_db, -100.0, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
			$Tween.start()
			$UI/AnimationPlayer.play("exit")
	
	current_state = new_state


func change_scene(scene):
	$Music.stop()
	$Ambience.stop()
	get_tree().change_scene(scene)


func phase_ended():
	current_phase += 1
	if current_phase >= $YSort/Phases.get_child_count():
		win()
	else:
		$YSort/Phases.get_child(current_phase).start_phase()


func win():
	_change_state(WIN)


func _on_ui_animation_finished(name):
	match name:
		"SETUP":
			$UI/AnimationPlayer.play("enter")
		"exit":
			if current_state == WIN:
				change_scene(WinMenu)
			elif current_state == PLAYER_DIED:
				change_scene(MainMenu)
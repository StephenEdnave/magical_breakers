extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$CanvasLayer/MainMenuContainer/Buttons/PlayButton.connect("button_down", self, "_on_PlayButton_button_down")
	$CanvasLayer/MainMenuContainer/Buttons/HowToPlayButton.connect("button_down", self, "_on_HowToPlayButton_button_down")
	$CanvasLayer/MainMenuContainer/Buttons/ExitButton.connect("button_down", self, "_on_ExitButton_button_down")
	$CanvasLayer/HowToPlayMenuContainer/ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")
	
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("open_main_menu")


func _on_PlayButton_button_down():
	$Tween.interpolate_property($Music, "volume_db", $Music.volume_db, -100.0, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	$ButtonPress.play()
	$AnimationPlayer.play("main_menu_transition_out")


func _on_HowToPlayButton_button_down():
	$ButtonPress.play()
	$AnimationPlayer.play("main_menu_to_how_to_play")


func _on_ExitButton_button_down():
	$ButtonPress.play()
	get_tree().quit()


func _on_ReturnButton_button_down():
	$ButtonPress.play()
	$AnimationPlayer.play("how_to_play_to_main_menu")


func _on_animation_finished(name):
	match name:
		"open_main_menu":
			$AnimationPlayer.play("main_menu")
		"how_to_play_to_main_menu":
			$AnimationPlayer.play("open_main_menu")
		"main_menu_transition_out":
			get_tree().change_scene("res://Level.tscn")
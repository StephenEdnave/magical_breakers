extends Node2D

func _ready():
	$CanvasLayer/MainMenu/Buttons/PlayButton.connect("button_down", self, "_on_PlayButton_button_down")
	$CanvasLayer/MainMenu/Buttons/ConfigButton.connect("button_down", self, "_on_ConfigButton_button_down")
	$CanvasLayer/MainMenu/Buttons/ExitButton.connect("button_down", self, "_on_ExitButton_button_down")
	$CanvasLayer/MainMenu/Buttons/CreditsButton.connect("button_down", self, "_on_CreditsButton_button_down")
	$CanvasLayer/Config/ReturnButton.connect("button_down", self, "_on_ConfigReturnButton_button_down")
	$CanvasLayer/Credits/ReturnButton.connect("button_down", self, "_on_CreditsReturnButton_button_down")
	
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("open_main_menu")
	
	
	# Music/sound editing
	$CanvasLayer/Config/SoundPanel/SFXBar/VolumeBar.value = (AudioServer.get_bus_volume_db(1) + 60) / 60 * 100
	$CanvasLayer/Config/SoundPanel/MusicBar/VolumeBar.value = (AudioServer.get_bus_volume_db(2) + 60) / 60 * 100
	$CanvasLayer/Config/SoundPanel/SFXBar/MinusButton.connect("button_down", self, "_on_SFXDown_button_down")
	$CanvasLayer/Config/SoundPanel/SFXBar/PlusButton.connect("button_down", self, "_on_SFXUp_button_down")
	$CanvasLayer/Config/SoundPanel/MusicBar/MinusButton.connect("button_down", self, "_on_MusicDown_button_down")
	$CanvasLayer/Config/SoundPanel/MusicBar/PlusButton.connect("button_down", self, "_on_MusicUp_button_down")


func _on_PlayButton_button_down():
	$Tween.interpolate_property($Music, "volume_db", $Music.volume_db, -100.0, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	$ButtonPress.play()
	$AnimationPlayer.play("main_menu_transition_out")


func _on_ConfigButton_button_down():
	$ButtonPress.play()
	$AnimationPlayer.play("main_menu_to_config")


func _on_ExitButton_button_down():
	$ButtonPress.play()
	get_tree().quit()


func _on_CreditsButton_button_down():
	$ButtonPress.play()
	$AnimationPlayer.play("main_menu_to_credits")


func _on_ConfigReturnButton_button_down():
	$ButtonPress.play()
	$AnimationPlayer.play("config_to_main_menu")


func _on_CreditsReturnButton_button_down():
	$ButtonPress.play()
	$AnimationPlayer.play("credits_to_main_menu")


func _on_animation_finished(name):
	match name:
		"open_main_menu":
			$AnimationPlayer.play("main_menu")
		"config_to_main_menu":
			$AnimationPlayer.play("open_main_menu")
		"main_menu_transition_out":
			get_tree().change_scene("res://environment/in_the_sky/InTheSky.tscn")
		"credits_to_main_menu":
			$AnimationPlayer.play("open_main_menu")


func _on_SFXDown_button_down():
	var bus_index = AudioServer.get_bus_index("SFX")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume -= 3
	volume = max(volume, -30.0)
	if not volume == -30.0:
		AudioServer.set_bus_mute(bus_index, false)
	else:
		AudioServer.set_bus_mute(bus_index, true)
	AudioServer.set_bus_volume_db(bus_index, volume)
	$ButtonPress.play()
	var progress = (volume + 30) / 30 * 100
	$CanvasLayer/Config/SoundPanel/SFXBar/VolumeBar.value = progress
	$CanvasLayer/Config/SoundPanel/SFXBar/PercentLabel.text = str(progress) + "%"


func _on_SFXUp_button_down():
	var bus_index = AudioServer.get_bus_index("SFX")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume += 3
	volume = min(volume, 0.0)
	if not volume == -30.0:
		AudioServer.set_bus_mute(bus_index, false)
	else:
		AudioServer.set_bus_mute(bus_index, true)
	AudioServer.set_bus_volume_db(bus_index, volume)
	$ButtonPress.play()
	var progress = (volume + 30) / 30 * 100
	$CanvasLayer/Config/SoundPanel/SFXBar/VolumeBar.value = progress
	$CanvasLayer/Config/SoundPanel/SFXBar/PercentLabel.text = str(progress) + "%"


func _on_MusicDown_button_down():
	var bus_index = AudioServer.get_bus_index("Music")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume -= 3
	volume = max(volume, -30.0)
	if not volume == -30.0:
		AudioServer.set_bus_mute(bus_index, false)
	else:
		AudioServer.set_bus_mute(bus_index, true)
	AudioServer.set_bus_volume_db(bus_index, volume)
	$ButtonPress.play()
	var progress = (volume + 30) / 30 * 100
	$CanvasLayer/Config/SoundPanel/MusicBar/VolumeBar.value = progress
	$CanvasLayer/Config/SoundPanel/MusicBar/PercentLabel.text = str(progress) + "%"


func _on_MusicUp_button_down():
	var bus_index = AudioServer.get_bus_index("Music")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume += 3
	volume = min(volume, 0.0)
	if not volume == -30.0:
		AudioServer.set_bus_mute(bus_index, false)
	else:
		AudioServer.set_bus_mute(bus_index, true)
	AudioServer.set_bus_volume_db(bus_index, volume)
	$ButtonPress.play()
	var progress = (volume + 30) / 30 * 100
	$CanvasLayer/Config/SoundPanel/MusicBar/VolumeBar.value = progress
	$CanvasLayer/Config/SoundPanel/MusicBar/PercentLabel.text = str(progress) + "%"
extends Container

var main_menu = null

func _ready():
	$ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")
	
	# Music/sound editing
	$SoundPanel/SFXBar/VolumeBar.value = (AudioServer.get_bus_volume_db(1) + 60) / 60 * 100
	$SoundPanel/MusicBar/VolumeBar.value = (AudioServer.get_bus_volume_db(2) + 60) / 60 * 100
	$SoundPanel/SFXBar/MinusButton.connect("button_down", self, "_on_SFXDown_button_down")
	$SoundPanel/SFXBar/PlusButton.connect("button_down", self, "_on_SFXUp_button_down")
	$SoundPanel/MusicBar/MinusButton.connect("button_down", self, "_on_MusicDown_button_down")
	$SoundPanel/MusicBar/PlusButton.connect("button_down", self, "_on_MusicUp_button_down")


func setup(_main_menu):
	main_menu = _main_menu
	set_process_input(false)


func enter():
	set_process_input(true)


func _on_ReturnButton_button_down():
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("config_to_main_menu")


func _change_SFX_volume(volume):
	var bus_index = AudioServer.get_bus_index("SFX")
	if volume == -10.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
	AudioServer.set_bus_volume_db(bus_index, volume)
	main_menu.get_node("ButtonPress").play()
	var progress = (volume + 10) / 10 * 100
	$SoundPanel/SFXBar/VolumeBar.value = progress
	$SoundPanel/SFXBar/PercentLabel.text = str(progress) + "%"


func _on_SFXDown_button_down():
	var bus_index = AudioServer.get_bus_index("SFX")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume -= 1
	volume = max(volume, -10.0)
	_change_SFX_volume(volume)


func _on_SFXUp_button_down():
	var bus_index = AudioServer.get_bus_index("SFX")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume += 1
	volume = min(volume, 0.0)
	_change_SFX_volume(volume)


func _change_music_volume(volume):
	var bus_index = AudioServer.get_bus_index("Music")
	if volume == -10.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
	AudioServer.set_bus_volume_db(bus_index, volume)
	main_menu.get_node("ButtonPress").play()
	var progress = (volume + 10) / 10 * 100
	$SoundPanel/MusicBar/VolumeBar.value = progress
	$SoundPanel/MusicBar/PercentLabel.text = str(progress) + "%"


func _on_MusicDown_button_down():
	var bus_index = AudioServer.get_bus_index("Music")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume -= 1
	volume = max(volume, -10.0)
	_change_music_volume(volume)


func _on_MusicUp_button_down():
	var bus_index = AudioServer.get_bus_index("Music")
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume += 1
	volume = min(volume, 0.0)
	_change_music_volume(volume)
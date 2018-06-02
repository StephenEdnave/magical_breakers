extends Container

var main_menu = null

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)

func _ready():
	$ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")
	
	# Music/sound editing
	$SoundPanel/SFXBar/VolumeBar.value = (AudioServer.get_bus_volume_db(1) + 60) / 60 * 100
	$SoundPanel/MusicBar/VolumeBar.value = (AudioServer.get_bus_volume_db(2) + 60) / 60 * 100
	$SoundPanel/SFXBar/MinusButton.connect("button_down", self, "_on_SFXDown_button_down")
	$SoundPanel/SFXBar/PlusButton.connect("button_down", self, "_on_SFXUp_button_down")
	$SoundPanel/MusicBar/MinusButton.connect("button_down", self, "_on_MusicDown_button_down")
	$SoundPanel/MusicBar/PlusButton.connect("button_down", self, "_on_MusicUp_button_down")


func setup(_main_menu, _pointer_scene):
	main_menu = _main_menu
	set_process_input(false)
	
	pointer_scene = _pointer_scene
	pointer = pointer_scene.instance()
	add_child(pointer)
	pointer.visible = false


func enter():
	set_process_input(true)
	pointer.visible = true
	pointer.global_position = $ReturnButton.rect_global_position + POINTER_OFFSET


func _input(event):
	if event.is_action_pressed("ui_select"):
		$ReturnButton.emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		$ReturnButton.emit_signal("button_down")


func _on_ReturnButton_button_down():
	set_process_input(false)
	pointer.visible = false
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
extends Container

signal exit

const POINTER_OFFSET = Vector2(-20.0, -10.0)
var pointer = null

enum STATES { PANEL_SELECTION, VOLUME_CHANGE }
var state = STATES.PANEL_SELECTION
enum PANELS { SFX, MUSIC }
var panel_selection = PANELS.SFX
enum VOLUME_CHANGE { DECREASE, INCREASE }
var volume_selection = VOLUME_CHANGE.DECREASE



func _ready():
	set_process_input(false)
	visible = false
	
	$SoundPanel/SFXBar/VolumeBar.value = (AudioServer.get_bus_volume_db(1) + 60) / 60 * 100
	$SoundPanel/MusicBar/VolumeBar.value = (AudioServer.get_bus_volume_db(2) + 60) / 60 * 100
	$SoundPanel/SFXBar/MinusButton.connect("button_down", self, "_change_volume", ["SFX", -1])
	$SoundPanel/SFXBar/PlusButton.connect("button_down", self, "_change_volume", ["SFX", 1])
	$SoundPanel/MusicBar/MinusButton.connect("button_down", self, "_change_volume", ["Music", -1])
	$SoundPanel/MusicBar/PlusButton.connect("button_down", self, "_change_volume", ["Music", 1])
	
	$ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")


func setup(pointer_scene):
	pointer = pointer_scene.instance()
	add_child(pointer)


func enter():
	state = STATES.PANEL_SELECTION
	panel_selection = PANELS.SFX
	volume_selection = VOLUME_CHANGE.DECREASE
	
	set_process_input(true)
	visible = true
	update_pointer()


func exit():
	set_process_input(false)
	visible = false
	emit_signal("exit")


func _input(event):
	match state:
		STATES.PANEL_SELECTION:
			if event.is_action_pressed("ui_select"):
				state = STATES.VOLUME_CHANGE
				volume_selection = VOLUME_CHANGE.DECREASE
				update_pointer()
			elif event.is_action_pressed("ui_cancel"):
				exit()
			elif event.is_action_pressed("ui_up"):
				panel_selection -= 1
				if panel_selection < 0:
					panel_selection = PANELS.size() - 1
				update_pointer()
			elif event.is_action_pressed("ui_down"):
				panel_selection += 1
				if panel_selection >= PANELS.size():
					panel_selection = 0
				update_pointer()
		STATES.VOLUME_CHANGE:
			if event.is_action_pressed("ui_select"):
				match panel_selection:
					PANELS.SFX:
						match volume_selection:
							VOLUME_CHANGE.DECREASE:
								$SoundPanel/SFXBar/MinusButton.emit_signal("button_down")
							VOLUME_CHANGE.INCREASE:
								$SoundPanel/SFXBar/PlusButton.emit_signal("button_down")
					PANELS.MUSIC:
						match volume_selection:
							VOLUME_CHANGE.DECREASE:
								$SoundPanel/MusicBar/MinusButton.emit_signal("button_down")
							VOLUME_CHANGE.INCREASE:
								$SoundPanel/MusicBar/PlusButton.emit_signal("button_down")
				update_pointer()
			elif event.is_action_pressed("ui_cancel"):
				state = STATES.PANEL_SELECTION
				update_pointer()
			elif event.is_action_pressed("ui_left"):
				volume_selection -= 1
				if volume_selection < 0:
					volume_selection = VOLUME_CHANGE.size() - 1
				update_pointer()
			elif event.is_action_pressed("ui_right"):
				volume_selection += 1
				if volume_selection >= VOLUME_CHANGE.size():
					volume_selection = 0
				update_pointer()


func _change_volume(bus_name, volume_change):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume = AudioServer.get_bus_volume_db(bus_index)
	volume += volume_change
	volume = clamp(volume, -10.0, 0)
	if volume == -10.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
	AudioServer.set_bus_volume_db(bus_index, volume)
	var progress = (volume + 10) / 10 * 100
	match bus_name:
		"SFX":
			$SoundPanel/SFXBar/VolumeBar.value = progress
			$SoundPanel/SFXBar/PercentLabel.text = str(progress) + "%"
			$TestSFX.play()
		"Music":
			$SoundPanel/MusicBar/VolumeBar.value = progress
			$SoundPanel/MusicBar/PercentLabel.text = str(progress) + "%"


func update_pointer():
	match state:
		STATES.PANEL_SELECTION:
			match panel_selection:
				PANELS.SFX:
					pointer.global_position = $SoundPanel/SFXLabel.rect_global_position + POINTER_OFFSET
				PANELS.MUSIC:
					pointer.global_position = $SoundPanel/MusicLabel.rect_global_position + POINTER_OFFSET
		STATES.VOLUME_CHANGE:
			match panel_selection:
				PANELS.SFX:
					match volume_selection:
						VOLUME_CHANGE.DECREASE:
							pointer.global_position = $SoundPanel/SFXBar/MinusButton.rect_global_position + POINTER_OFFSET
						VOLUME_CHANGE.INCREASE:
							pointer.global_position = $SoundPanel/SFXBar/PlusButton.rect_global_position + POINTER_OFFSET
				PANELS.MUSIC:
					match volume_selection:
						VOLUME_CHANGE.DECREASE:
							pointer.global_position = $SoundPanel/MusicBar/MinusButton.rect_global_position + POINTER_OFFSET
						VOLUME_CHANGE.INCREASE:
							pointer.global_position = $SoundPanel/MusicBar/PlusButton.rect_global_position + POINTER_OFFSET


func _on_ReturnButton_button_down():
	exit()
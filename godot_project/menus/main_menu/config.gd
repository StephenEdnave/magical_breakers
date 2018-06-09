extends Container

var main_menu = null

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)

var INPUT_ACTIONS = ["move_up", "move_down", "move_left", "move_right", "primary_attack", "secondary_attack", "special_attack", "lock_on", "dash"]
var input_to_change = 0
var input_selected = 0
var input_index = 0 # For primary/secondary/more events for a single action
var old_action = ""
var old_action_name = ""
var action_name = ""

enum STATES { CONFIG, INPUT_CONFIG }
var current_state = null

func _ready():
	$ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")
	
	# Input editing
	$InputContainer/UpButton.connect("button_down", self, "_change_input", ["move_up"])
	$InputContainer/DownButton.connect("button_down", self, "_change_input", ["move_down"])
	$InputContainer/LeftButton.connect("button_down", self, "_change_input", ["move_left"])
	$InputContainer/RightButton.connect("button_down", self, "_change_input", ["move_right"])
	$InputContainer/PrimaryAttackButton.connect("button_down", self, "_change_input", ["primary_attack"])
	$InputContainer/SecondaryAttackButton.connect("button_down", self, "_change_input", ["secondary_attack"])
	$InputContainer/Skill1Button.connect("button_down", self, "_change_input", ["skill_1"])
	$InputContainer/Skill2Button.connect("button_down", self, "_change_input", ["skill_2"])
	$InputContainer/Skill3Button.connect("button_down", self, "_change_input", ["skill_3"])
	$InputContainer/Skill4Button.connect("button_down", self, "_change_input", ["skill_4"])
	$InputContainer/LockOnButton.connect("button_down", self, "_change_input", ["lock_on"])
	$InputContainer/DashButton.connect("button_down", self, "_change_input", ["dash"])
	$InputChange/VBoxContainer/Buttons/AcceptButton.connect("button_down", self, "_on_InputAccept_button_down")
	$InputChange/VBoxContainer/Buttons/CancelButton.connect("button_down", self, "_on_InputCancel_button_down")
	
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
	
	current_state = CONFIG


func _input(event):
	if current_state == CONFIG:
		if event.is_action_pressed("ui_select"):
			$ReturnButton.emit_signal("button_down")
		elif event.is_action_pressed("ui_cancel"):
			$ReturnButton.emit_signal("button_down")
	elif current_state == INPUT_CONFIG:
		if not event is InputEventKey:
			return
		if not event.is_pressed():
			return
		if event.scancode == KEY_ESCAPE:
			$InputChange/VBoxContainer/Buttons/CancelButton.emit_signal("button_down")
		_check_input(event)


func _check_input(event):
	var input_good = true
	var conflicting_action = ""
	for action in InputMap.get_actions():
		if InputMap.action_has_event(action, event):
			if input_to_change == action:
				continue
			if action == "ui_select" or action == "ui_cancel" or action == "ui_up" or action == "ui_down" or action == "ui_left" or action == "ui_right":
				continue
			
			input_good = false
			conflicting_action = action
			break
	
	$InputChange/VBoxContainer/NewInput.text = event.as_text()
	if input_good:
		$InputChange/VBoxContainer/InputStatusLabel.text = "No conflicts"
		$InputChange/VBoxContainer/InputStatusLabel.add_color_override("font_color", Color(0.0, 1.0, 0.0, 1.0))
		$InputChange/VBoxContainer/Buttons/AcceptButton.disabled = false
		input_selected = event
	else:
		match conflicting_action:
			"primary_attack":
				action_name = "Primary attack"
			"secondary_attack":
				action_name = "Secondary attack"
			"move_up":
				action_name = "Move up"
			"move_down":
				action_name = "Move down"
			"move_left":
				action_name = "Move left"
			"move_right":
				action_name = "Move right"
			"special_attack":
				action_name = "Special attack"
			"lock_on":
				action_name = "Lock on"
			"dash":
				action_name = "Dash"
		$InputChange/VBoxContainer/InputStatusLabel.text = "Conflicts with " + action_name
		$InputChange/VBoxContainer/InputStatusLabel.add_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
		$InputChange/VBoxContainer/Buttons/AcceptButton.disabled = true


func _change_input(target_input):
	current_state = INPUT_CONFIG
	input_to_change = target_input
	old_action = InputMap.get_action_list(target_input)
	
	match input_to_change:
		"primary_attack":
			old_action_name = "Primary attack"
		"secondary_attack":
			old_action_name = "Secondary attack"
		"move_up":
			old_action_name = "Move up"
		"move_down":
			old_action_name = "Move down"
		"move_left":
			old_action_name = "Move left"
		"move_right":
			old_action_name = "Move right"
		"special_attack":
			old_action_name = "Special attack"
		"lock_on":
			old_action_name = "Lock on"
		"dash":
			old_action_name = "Dash"
	
	$InputChange/VBoxContainer/InputToChange.text = old_action_name
	$InputChange/VBoxContainer/NewInput.text = ""
	$InputChange/VBoxContainer/InputStatusLabel.text = "Choose an input"
	$InputChange/VBoxContainer/InputStatusLabel.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	$InputChange/VBoxContainer/Buttons/AcceptButton.disabled = true
	
	$InputChange.visible = true
	$InputContainer.visible = false
	$SoundPanel.visible = false
	$ReturnButton.visible = false
	pointer.visible = false


func _on_InputAccept_button_down():
	main_menu.get_node("ButtonPress").play()
	current_state = CONFIG
	$InputChange.visible = false
	$InputContainer.visible = true
	$SoundPanel.visible = true
	$ReturnButton.visible = true
	pointer.visible = true
	
	var event_to_delete = InputMap.get_action_list(input_to_change)[input_index]
	InputMap.action_erase_event(input_to_change, event_to_delete)
	InputMap.action_add_event(input_to_change, input_selected)
	
	match input_to_change:
		"move_up":
			$InputContainer/UpButton.text = input_selected.as_text()
			input_to_change = "ui_up"
		"move_down":
			$InputContainer/DownButton.text = input_selected.as_text()
			input_to_change = "ui_down"
		"move_left":
			$InputContainer/LeftButton.text = input_selected.as_text()
			input_to_change = "ui_left"
		"move_right":
			$InputContainer/RightButton.text = input_selected.as_text()
			input_to_change = "ui_right"
		"primary_attack":
			$InputContainer/PrimaryAttackButton.text = input_selected.as_text()
			input_to_change = "ui_select"
		"secondary_attack":
			$InputContainer/SecondaryAttackButton.text = input_selected.as_text()
			input_to_change = "ui_cancel"
		"skill_1":
			$InputContainer/Skill1Button.text = input_selected.as_text()
		"skill_2":
			$InputContainer/Skill2Button.text = input_selected.as_text()
		"skill_3":
			$InputContainer/Skill3Button.text = input_selected.as_text()
		"skill_4":
			$InputContainer/Skill4Button.text = input_selected.as_text()
		"lock_on":
			$InputContainer/LockOnButton.text = input_selected.as_text()
		"dash":
			$InputContainer/DashButton.text = input_selected.as_text()
		_:
			return
	
	# For if we're additionally changing a ui button (handled separately from gameplay
	event_to_delete = InputMap.get_action_list(input_to_change)[input_index]
	event_to_delete = InputMap.get_action_list(input_to_change)[input_index]
	InputMap.action_erase_event(input_to_change, event_to_delete)
	InputMap.action_add_event(input_to_change, input_selected)


func _on_InputCancel_button_down():
	main_menu.get_node("ButtonPress").play()
	current_state = CONFIG
	$InputChange.visible = false
	$InputContainer.visible = true
	$SoundPanel.visible = true
	$ReturnButton.visible = true
	pointer.visible = true




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
extends Container

signal exit

const POINTER_OFFSET = Vector2(-20.0, 0.0)
var pointer = null
var current_selection = 0

var INPUT_ACTIONS = ["move_up", "move_down", "move_left", "move_right", "primary_attack", "secondary_attack", "skill_1", "skill_2", "skill_3", "skill_4", "lock_on", "dash"]
var input_to_change = 0
var input_selected = 0
var input_index = 0 # For primary/secondary/more events for a single action
var old_action = ""
var old_action_name = ""
var action_name = ""

enum STATES { INPUT_SELECTION, CONFIRM }
var state = STATES.INPUT_SELECTION


func _ready():
	set_process_input(false)
	visible = false
	
	$GridContainer/UpButton.connect("button_down", self, "_change_input", ["move_up"])
	$GridContainer/DownButton.connect("button_down", self, "_change_input", ["move_down"])
	$GridContainer/LeftButton.connect("button_down", self, "_change_input", ["move_left"])
	$GridContainer/RightButton.connect("button_down", self, "_change_input", ["move_right"])
	$GridContainer/PrimaryAttackButton.connect("button_down", self, "_change_input", ["primary_attack"])
	$GridContainer/SecondaryAttackButton.connect("button_down", self, "_change_input", ["secondary_attack"])
	$GridContainer/Skill1Button.connect("button_down", self, "_change_input", ["skill_1"])
	$GridContainer/Skill2Button.connect("button_down", self, "_change_input", ["skill_2"])
	$GridContainer/Skill3Button.connect("button_down", self, "_change_input", ["skill_3"])
	$GridContainer/Skill4Button.connect("button_down", self, "_change_input", ["skill_4"])
	$GridContainer/LockOnButton.connect("button_down", self, "_change_input", ["lock_on"])
	$GridContainer/DashButton.connect("button_down", self, "_change_input", ["dash"])
	$InputChange/VBoxContainer/Buttons/AcceptButton.connect("button_down", self, "_on_InputAccept_button_down")
	$InputChange/VBoxContainer/Buttons/CancelButton.connect("button_down", self, "_on_InputCancel_button_down")
	
	$ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")


func setup(pointer_scene):
	pointer = pointer_scene.instance()
	add_child(pointer)


func enter():
	state = STATES.INPUT_SELECTION
	current_selection = 0
	
	set_process_input(true)
	visible = true
	update_pointer()


func exit():
	set_process_input(false)
	visible = false
	emit_signal("exit")


func _input(event):
	match state:
		STATES.INPUT_SELECTION:
			if event.is_action_pressed("ui_select"):
				_change_input(INPUT_ACTIONS[current_selection])
			elif event.is_action_pressed("ui_cancel"):
				exit()
			elif event.is_action_pressed("ui_up"):
				if state == STATES.INPUT_SELECTION:
					current_selection -= 1
					if current_selection < 0:
						current_selection = INPUT_ACTIONS.size() - 1
					update_pointer()
			elif event.is_action_pressed("ui_down"):
				if state == STATES.INPUT_SELECTION:
					current_selection += 1
					if current_selection >= INPUT_ACTIONS.size():
						current_selection = 0
					update_pointer()
		STATES.CONFIRM:
			if not event is InputEventKey:
				return
			if not event.is_pressed():
				return
			
			#if event.scancode == KEY_ESCAPE:
			#	$InputChange/VBoxContainer/Buttons/CancelButton.emit_signal("button_down")
			_check_input(event)


func _change_input(target_input):
	state = STATES.INPUT_SELECTION
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
	$GridContainer.visible = false
	
	state = STATES.CONFIRM
	pointer.visible = false


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


func _on_InputAccept_button_down():
	$ButtonPress.play()
	state = STATES.INPUT_SELECTION
	$InputChange.visible = false
	$GridContainer.visible = true
	
	var event_to_delete = InputMap.get_action_list(input_to_change)[input_index]
	InputMap.action_erase_event(input_to_change, event_to_delete)
	InputMap.action_add_event(input_to_change, input_selected)
	
	match input_to_change:
		"move_up":
			$GridContainer/UpButton.text = input_selected.as_text()
			input_to_change = "ui_up"
		"move_down":
			$GridContainer/DownButton.text = input_selected.as_text()
			input_to_change = "ui_down"
		"move_left":
			$GridContainer/LeftButton.text = input_selected.as_text()
			input_to_change = "ui_left"
		"move_right":
			$GridContainer/RightButton.text = input_selected.as_text()
			input_to_change = "ui_right"
		"primary_attack":
			$GridContainer/PrimaryAttackButton.text = input_selected.as_text()
			input_to_change = "ui_select"
		"secondary_attack":
			$GridContainer/SecondaryAttackButton.text = input_selected.as_text()
			input_to_change = "ui_cancel"
		"skill_1":
			$GridContainer/Skill1Button.text = input_selected.as_text()
		"skill_2":
			$GridContainer/Skill2Button.text = input_selected.as_text()
		"skill_3":
			$GridContainer/Skill3Button.text = input_selected.as_text()
		"skill_4":
			$GridContainer/Skill4Button.text = input_selected.as_text()
		"lock_on":
			$GridContainer/LockOnButton.text = input_selected.as_text()
		"dash":
			$GridContainer/DashButton.text = input_selected.as_text()
		_:
			return
	
	# For if we're additionally changing a ui button (handled separately from gameplay)
	event_to_delete = InputMap.get_action_list(input_to_change)[input_index]
	event_to_delete = InputMap.get_action_list(input_to_change)[input_index]
	InputMap.action_erase_event(input_to_change, event_to_delete)
	InputMap.action_add_event(input_to_change, input_selected)


func _on_InputCancel_button_down():
	$ButtonPress.play()
	state = STATES.INPUT_SELECTION
	$InputChange.visible = false
	$GridContainer.visible = true


func update_pointer():
	pointer.visible = true
	match INPUT_ACTIONS[current_selection]:
		"move_up":
			pointer.global_position = $GridContainer/UpButton.rect_global_position + POINTER_OFFSET
		"move_down":
			pointer.global_position = $GridContainer/DownButton.rect_global_position + POINTER_OFFSET
		"move_left":
			pointer.global_position = $GridContainer/LeftButton.rect_global_position + POINTER_OFFSET
		"move_right":
			pointer.global_position = $GridContainer/RightButton.rect_global_position + POINTER_OFFSET
		"primary_attack":
			pointer.global_position = $GridContainer/PrimaryAttackButton.rect_global_position + POINTER_OFFSET
		"secondary_attack":
			pointer.global_position = $GridContainer/SecondaryAttackButton.rect_global_position + POINTER_OFFSET
		"skill_1":
			pointer.global_position = $GridContainer/Skill1Button.rect_global_position + POINTER_OFFSET
		"skill_2":
			pointer.global_position = $GridContainer/Skill2Button.rect_global_position + POINTER_OFFSET
		"skill_3":
			pointer.global_position = $GridContainer/Skill3Button.rect_global_position + POINTER_OFFSET
		"skill_4":
			pointer.global_position = $GridContainer/Skill4Button.rect_global_position + POINTER_OFFSET
		"lock_on":
			pointer.global_position = $GridContainer/LockOnButton.rect_global_position + POINTER_OFFSET
		"dash":
			pointer.global_position = $GridContainer/DashButton.rect_global_position + POINTER_OFFSET


func _on_ReturnButton_button_down():
	exit()
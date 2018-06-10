extends PanelContainer

var main_menu = null

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)

enum PANELS { DISPLAY, AUDIO, KEYBINDINGS }
var panel_selection = PANELS.DISPLAY
enum STATES { PANEL_SELECTION, IN_PANEL, RETURN }
var state = STATES.PANEL_SELECTION


func _ready():
	set_process_input(false)
	
	$ConfigButtons/PanelButtons/DisplayButton.connect("button_down", self, "_enter_panel", [PANELS.DISPLAY])
	$ConfigButtons/PanelButtons/AudioButton.connect("button_down", self, "_enter_panel", [PANELS.AUDIO])
	$ConfigButtons/PanelButtons/KeybindingsButton.connect("button_down", self, "_enter_panel", [PANELS.KEYBINDINGS])
	$ConfigButtons/ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")
	
	$Display.connect("exit", self, "_exit_panel", [PANELS.DISPLAY])
	$Audio.connect("exit", self, "_exit_panel", [PANELS.AUDIO])
	$Keybindings.connect("exit", self, "_exit_panel", [PANELS.KEYBINDINGS])


func setup(_main_menu, _pointer_scene):
	main_menu = _main_menu
	
	pointer_scene = _pointer_scene
	pointer = pointer_scene.instance()
	add_child(pointer)
	pointer.visible = false
	
	$Display.setup(pointer_scene)
	$Audio.setup(pointer_scene)
	$Keybindings.setup(pointer_scene)


func enter():
	set_process_input(true)
	$ConfigButtons.visible = true
	pointer.visible = true
	panel_selection = PANELS.DISPLAY
	state = STATES.PANEL_SELECTION
	update_pointer()


func _input(event):
	if event.is_action_pressed("ui_select"):
		match state:
			STATES.PANEL_SELECTION:
				match panel_selection:
					PANELS.DISPLAY:
						$ConfigButtons/PanelButtons/DisplayButton.emit_signal("button_down")
					PANELS.AUDIO:
						$ConfigButtons/PanelButtons/AudioButton.emit_signal("button_down")
					PANELS.KEYBINDINGS:
						$ConfigButtons/PanelButtons/KeybindingsButton.emit_signal("button_down")
				state = STATES.IN_PANEL
			STATES.RETURN:
				$ConfigButtons/ReturnButton.emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		state = STATES.RETURN
		update_pointer()
	elif event.is_action_pressed("ui_up"):
		match state:
			STATES.PANEL_SELECTION:
				state = STATES.RETURN
				update_pointer()
			STATES.RETURN:
				state = STATES.PANEL_SELECTION
				update_pointer()
	elif event.is_action_pressed("ui_down"):
		match state:
			STATES.PANEL_SELECTION:
				state = STATES.RETURN
				update_pointer()
			STATES.RETURN:
				state = STATES.PANEL_SELECTION
				update_pointer()
	elif event.is_action_pressed("ui_left"):
		match state:
			STATES.PANEL_SELECTION:
				panel_selection -= 1
				if panel_selection < 0:
					panel_selection = PANELS.size() - 1
				update_pointer()
	elif event.is_action_pressed("ui_right"):
		match state:
			STATES.PANEL_SELECTION:
				panel_selection += 1
				if panel_selection >= PANELS.size():
					panel_selection = 0
				update_pointer()


func _enter_panel(new_panel):
	set_process_input(false)
	
	state = STATES.IN_PANEL
	update_pointer()
	
	$ConfigButtons.visible = false
	
	panel_selection = new_panel
	var panel
	match panel_selection:
		PANELS.DISPLAY:
			panel = $Display
		PANELS.AUDIO:
			panel = $Audio
		PANELS.KEYBINDINGS:
			panel = $Keybindings
	panel.enter()


func _exit_panel(panel):
	panel_selection = panel
	state = STATES.PANEL_SELECTION
	update_pointer()
	$ConfigButtons.visible = true
	set_process_input(true)


func _on_ReturnButton_button_down():
	set_process_input(false)
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("config_to_main_menu")


func update_pointer():
	match state:
		STATES.PANEL_SELECTION:
			pointer.global_position = $ConfigButtons/PanelButtons.get_child(panel_selection).rect_global_position + POINTER_OFFSET
			pointer.visible = true
		STATES.RETURN:
			pointer.global_position = $ConfigButtons/ReturnButton.rect_global_position + POINTER_OFFSET
			pointer.visible = true
		STATES.IN_PANEL:
			pointer.visible = false

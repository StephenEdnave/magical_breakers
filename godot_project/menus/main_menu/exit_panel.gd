extends Panel

var main_menu = null

var quit_selected = true


func _ready():
	$YesButton.connect("button_down", self, "quit_to_desktop")
	$NoButton.connect("button_down", self, "_cancel_quit")


func setup(_main_menu):
	main_menu = _main_menu
	set_process_input(false)


func enter():
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		quit_selected = not quit_selected
	elif event.is_action_pressed("ui_select"):
		if quit_selected:
			$YesButton.emit_signal("button_down")
		else:
			$NoButton.emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		$NoButton.emit_signal("button_down")


func quit_to_desktop():
	main_menu.get_node("ButtonPress").play()
	get_tree().quit()


func _cancel_quit():
	set_process_input(false)
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("CanvasLayer").get_node("StartMenu").visible = true
	main_menu.get_node("CanvasLayer").get_node("StartMenu").enter()
	visible = false
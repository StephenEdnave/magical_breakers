extends Panel

var main_menu = null

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)

var quit_selected = true


func _ready():
	$YesButton.connect("button_down", self, "quit_to_desktop")
	$NoButton.connect("button_down", self, "_cancel_quit")


func setup(_main_menu, _pointer_scene):
	main_menu = _main_menu
	set_process_input(false)
	
	pointer_scene = _pointer_scene
	pointer = pointer_scene.instance()
	add_child(pointer)
	pointer.visible = false


func enter():
	set_process_input(true)
	quit_selected = false
	
	pointer.visible = true
	pointer.global_position = $NoButton.rect_global_position + POINTER_OFFSET
	main_menu.get_node("AnimationPlayer").play("exit")


func _input(event):
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		main_menu.get_node("ButtonPress").play()
		quit_selected = not quit_selected
	elif event.is_action_pressed("ui_select"):
		if quit_selected:
			$YesButton.emit_signal("button_down")
		else:
			$NoButton.emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		$NoButton.emit_signal("button_down")
	
	if quit_selected:
		pointer.global_position = $YesButton.rect_global_position + POINTER_OFFSET
	else:
		pointer.global_position = $NoButton.rect_global_position + POINTER_OFFSET


func quit_to_desktop():
	main_menu.get_node("ButtonPress").play()
	get_tree().quit()


func _cancel_quit():
	set_process_input(false)
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("CanvasLayer").get_node("StartMenu").visible = true
	main_menu.get_node("CanvasLayer").get_node("StartMenu").enter()
	visible = false
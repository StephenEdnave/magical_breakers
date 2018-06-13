extends Container

var main_menu = null

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)

var BUTTON_AMOUNT = 0
var current_selection = 0


func _ready():
	BUTTON_AMOUNT = $Buttons.get_child_count()
	$Buttons/PlayButton.connect("button_down", self, "_on_PlayButton_button_down")
	$Buttons/ConfigButton.connect("button_down", self, "_on_ConfigButton_button_down")
	$Buttons/ExitButton.connect("button_down", self, "_on_ExitButton_button_down")
	$Buttons/CreditsButton.connect("button_down", self, "_on_CreditsButton_button_down")
	
	$Buttons.get_child(BUTTON_AMOUNT - 1).focus_neighbour_bottom = $Buttons.get_child(0).get_path()
	$Buttons.get_child(0).focus_neighbour_top = $Buttons.get_child(BUTTON_AMOUNT - 1).get_path()


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
	pointer.global_position = $Buttons.get_child(current_selection).rect_global_position + POINTER_OFFSET


func _input(event):
	if event.is_action_pressed("ui_up"):
		main_menu.get_node("ButtonPress").play()
		current_selection -= 1
		if current_selection < 0:
			current_selection = BUTTON_AMOUNT - 1
	elif event.is_action_pressed("ui_down"):
		main_menu.get_node("ButtonPress").play()
		current_selection += 1
		if current_selection >= BUTTON_AMOUNT:
			current_selection = 0
	elif event.is_action_pressed("ui_select"):
		$Buttons.get_child(current_selection).emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		current_selection = BUTTON_AMOUNT - 1
		main_menu.get_node("ButtonPress").play()
	
	pointer.global_position = $Buttons.get_child(current_selection).rect_global_position + POINTER_OFFSET


func _on_PlayButton_button_down():
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_to_level_select")
	set_process_input(false)


func _on_ConfigButton_button_down():
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_to_config")
	set_process_input(false)


func _on_ExitButton_button_down():
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("CanvasLayer").get_node("ExitPanel").visible = true
	main_menu.get_node("CanvasLayer").get_node("ExitPanel").enter()
	visible = false
	set_process_input(false)


func _on_CreditsButton_button_down():
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_to_credits")
	set_process_input(false)
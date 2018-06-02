extends Container

var main_menu

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)

const LEVEL_AMOUNT = 2
var current_selection = 0
var level_names = ["Wonderland", "In the Sky"]
var confirm_selected = true

func _ready():
	$SelectButton.connect("button_down", self, "_select_level")
	$ReturnButton.connect("button_down", self, "_return_to_start_menu")


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
	pointer.global_position = $SelectButton.rect_global_position + POINTER_OFFSET


func _input(event):
	if event.is_action_pressed("ui_up"):
		main_menu.get_node("ButtonPress").play()
		current_selection += 1
		if current_selection >= LEVEL_AMOUNT:
			current_selection = 0
	elif event.is_action_pressed("ui_down"):
		main_menu.get_node("ButtonPress").play()
		current_selection -= 1
		if current_selection < 0:
			current_selection = LEVEL_AMOUNT - 1
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		main_menu.get_node("ButtonPress").play()
		confirm_selected = not confirm_selected
	elif event.is_action_pressed("ui_select"):
		if confirm_selected:
			$SelectButton.emit_signal("button_down")
		else:
			$ReturnButton.emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		$ReturnButton.emit_signal("button_down")
	
	if confirm_selected:
		pointer.global_position = $SelectButton.rect_global_position + POINTER_OFFSET
	else:
		pointer.global_position = $ReturnButton.rect_global_position + POINTER_OFFSET


func _select_level():
	pointer.visible = false
	GameManager.level_name = level_names[current_selection]
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("level_select_to_level_confirm")


func _return_to_start_menu():
	set_process_input(false)
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("level_select_to_main_menu")
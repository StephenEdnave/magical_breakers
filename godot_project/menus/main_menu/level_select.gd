extends Container

var main_menu

const LEVEL_AMOUNT = 2
var current_selection = 0
var level_names = ["Wonderland", "In the Sky"]
var confirm_selected = true

func _ready():
	$SelectButton.connect("button_down", self, "_select_level")
	$ReturnButton.connect("button_down", self, "_return_to_start_menu")


func setup(_main_menu):
	main_menu = _main_menu
	set_process_input(false)


func enter():
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("ui_up"):
		current_selection += 1
		if current_selection >= LEVEL_AMOUNT:
			current_selection = 0
	elif event.is_action_pressed("ui_down"):
		current_selection -= 1
		if current_selection < 0:
			current_selection = LEVEL_AMOUNT - 1
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		confirm_selected = not confirm_selected
	elif event.is_action_pressed("ui_select"):
		if confirm_selected:
			$SelectButton.emit_signal("button_down")
		else:
			$ReturnButton.emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		$ReturnButton.emit_signal("button_down")


func _select_level():
	GameManager.level_name = level_names[current_selection]
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("level_select_to_level_confirm")


func _return_to_start_menu():
	set_process_input(false)
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("level_select_to_main_menu")

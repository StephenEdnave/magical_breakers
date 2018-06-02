extends Container

var main_menu = null

var BUTTON_AMOUNT = 0
var current_selection = 0


func _ready():
	BUTTON_AMOUNT = $Buttons.get_child_count()
	$Buttons/PlayButton.connect("button_down", self, "_on_PlayButton_button_down")
	$Buttons/ConfigButton.connect("button_down", self, "_on_ConfigButton_button_down")
	$Buttons/ExitButton.connect("button_down", self, "_on_ExitButton_button_down")
	$Buttons/CreditsButton.connect("button_down", self, "_on_CreditsButton_button_down")


func setup(_main_menu):
	main_menu = _main_menu
	set_process_input(true)


func enter():
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("ui_up"):
		current_selection -= 1
		if current_selection < 0:
			current_selection = BUTTON_AMOUNT - 1
	elif event.is_action_pressed("ui_down"):
		current_selection += 1
		if current_selection >= BUTTON_AMOUNT:
			current_selection = 0
	elif event.is_action_pressed("ui_select"):
		$Buttons.get_child(current_selection).emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		current_selection = BUTTON_AMOUNT - 1


func _on_PlayButton_button_down():
	main_menu.get_node("Tween").interpolate_property(main_menu.get_node("Music"), "volume_db", main_menu.get_node("Music").volume_db, -100.0, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
	main_menu.get_node("Tween").start()
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_transition_out")
	set_process_input(false)


func _on_ConfigButton_button_down():
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_to_config")
	set_process_input(false)


func _on_ExitButton_button_down():
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("CanvasLayer").get_node("ExitPanel").visible = true
	main_menu.get_node("CanvasLayer").get_node("ExitPanel").enter()
	visible = false
	set_process_input(false)


func _on_CreditsButton_button_down():
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_to_credits")
	set_process_input(false)
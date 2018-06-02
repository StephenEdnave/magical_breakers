extends Container

var main_menu = null


func _ready():
	$ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")


func setup(_main_menu):
	main_menu = _main_menu
	set_process_input(false)


func enter():
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("ui_select") or event.is_action_pressed("ui_cancel"):
		$ReturnButton.emit_signal("button_down")


func _on_ReturnButton_button_down():
	set_process_input(false)
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("credits_to_main_menu")
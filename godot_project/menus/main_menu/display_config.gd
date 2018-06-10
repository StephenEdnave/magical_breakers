extends Container

signal exit

var config_menu = null


func _ready():
	set_process_input(false)
	visible = false
	
	$ReturnButton.connect("button_down", self, "exit")


func enter():
	set_process_input(true)
	visible = true


func exit():
	set_process_input(false)
	visible = false
	emit_signal("exit")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit()


func setup(_config_menu):
	config_menu = _config_menu
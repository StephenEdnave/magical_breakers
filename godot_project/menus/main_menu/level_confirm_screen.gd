extends Container

var main_menu = null

var confirm_selected = true
var level_paths = {
	"Wonderland" : "res://environment/wonderland/wonderland.tscn",
	"In the Sky" : "res://environment/in_the_sky/InTheSky.tscn"
	}


func _ready():
	$SelectButton.connect("button_down", self, "_confirm")
	$ReturnButton.connect("button_down", self, "_return_to_level_select")


func setup(_main_menu):
	main_menu = _main_menu
	set_process_input(false)


func enter():
	set_process_input(true)
	$NameLabel.text = GameManager.level_name


func _input(event):
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		confirm_selected = not confirm_selected
	elif event.is_action_pressed("ui_select"):
		if confirm_selected:
			$SelectButton.emit_signal("button_down")
		else:
			$ReturnButton.emit_signal("button_down")
	elif event.is_action_pressed("ui_cancel"):
		$ReturnButton.emit_signal("button_down")


func _confirm():
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_transition_out")
	yield(main_menu.get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene(level_paths[GameManager.level_name])


func _return_to_level_select():
	set_process_input(false)
	main_menu.get_node("ButtonPress").play()	
	main_menu.get_node("AnimationPlayer").play("level_confirm_to_level_select")
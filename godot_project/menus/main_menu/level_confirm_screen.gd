extends Container

var main_menu = null

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)

var confirm_selected = true
var level_paths = {
	"Wonderland" : "res://environment/wonderland/Wonderland.tscn",
	"In the Sky" : "res://environment/in_the_sky/InTheSky.tscn"
	}


func _ready():
	$SelectButton.connect("button_down", self, "_confirm")
	$ReturnButton.connect("button_down", self, "_return_to_level_select")


func setup(_main_menu, _pointer_scene):
	main_menu = _main_menu
	set_process_input(false)
	
	pointer_scene = _pointer_scene
	pointer = pointer_scene.instance()
	add_child(pointer)
	pointer.visible = false


func enter():
	set_process_input(true)
	$NameLabel.text = GameManager.level_name
	confirm_selected = true
	
	pointer.global_position = $SelectButton.rect_global_position + POINTER_OFFSET
	pointer.visible = true


func _input(event):
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
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


func _confirm():
	main_menu.get_node("Tween").interpolate_property(main_menu.get_node("Music"), "volume_db", main_menu.get_node("Music").volume_db, -100.0, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
	main_menu.get_node("Tween").start()
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("main_menu_transition_out")
	yield(main_menu.get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene(level_paths[GameManager.level_name])


func _return_to_level_select():
	set_process_input(false)
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("level_confirm_to_level_select")
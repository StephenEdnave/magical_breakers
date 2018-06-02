extends Container

var main_menu = null

var pointer_scene = null
var pointer = null
const POINTER_OFFSET = Vector2(-5.0, 0.0)


func _ready():
	$ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")


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
	pointer.global_position = $ReturnButton.rect_global_position + POINTER_OFFSET


func _input(event):
	if event.is_action_pressed("ui_select") or event.is_action_pressed("ui_cancel"):
		$ReturnButton.emit_signal("button_down")


func _on_ReturnButton_button_down():
	set_process_input(false)
	pointer.visible = false
	main_menu.get_node("ButtonPress").play()
	main_menu.get_node("AnimationPlayer").play("credits_to_main_menu")
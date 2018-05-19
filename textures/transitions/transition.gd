extends Node


var scene_path = ""


func _ready():
	$Tween.connect("tween_completed", self, "_on_Tween_completed")
	fade_out()

func fade_in(_scene_path):
	scene_path = _scene_path
	$Effect.visible = true
	$Tween.interpolate_property($Effect, "cutoff", -0.1, 1.1, 0.6, Tween.TRANS_QUAD, Tween.TRANS_LINEAR)
	$Tween.start()


func fade_out():
	$Effect.visible = true
	$Tween.interpolate_property($Effect, "cutoff", 1.1, -0.1, 0.6, Tween.TRANS_QUAD, Tween.TRANS_LINEAR)
	$Tween.start()


func _on_Tween_completed(object, key):
	var scene = scene_path
	if object.cutoff > 0.5:
		get_tree().change_scene(scene)
	else:
		$Effect.visible = false
extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$CanvasLayer/MainMenuContainer/PlayButton.connect("button_down", self, "_on_PlayButton_button_down")
	$CanvasLayer/MainMenuContainer/HowToPlayButton.connect("button_down", self, "_on_HowToPlayButton_button_down")
	$CanvasLayer/MainMenuContainer/ExitButton.connect("button_down", self, "_on_ExitButton_button_down")
	$CanvasLayer/HowToPlayMenuContainer/ReturnButton.connect("button_down", self, "_on_ReturnButton_button_down")


func _on_PlayButton_button_down():
	$Music.stop()
	$CanvasLayer/Transitions.fade_in("res://Level.tscn")


func _on_HowToPlayButton_button_down():
	$CanvasLayer/HowToPlayMenuContainer.visible = true
	$CanvasLayer/MainMenuContainer.visible = false


func _on_ExitButton_button_down():
	get_tree().quit()


func _on_ReturnButton_button_down():
	$CanvasLayer/MainMenuContainer.visible = true
	$CanvasLayer/HowToPlayMenuContainer.visible = false
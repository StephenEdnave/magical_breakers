extends Node2D

onready var MainMenuPointer = preload("res://menus/MainMenuPointer.tscn")
var pointer = null

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("SETUP")
	
	$CanvasLayer/Credits.setup(self, MainMenuPointer)
	$CanvasLayer/Config.setup(self, MainMenuPointer)
	$CanvasLayer/StartMenu.setup(self, MainMenuPointer)
	$CanvasLayer/LevelSelect.setup(self, MainMenuPointer)
	$CanvasLayer/LevelConfirmScreen.setup(self, MainMenuPointer)
	$CanvasLayer/ExitPanel.setup(self, MainMenuPointer)
	
	pointer = MainMenuPointer.instance()
	add_child(pointer)


func _on_animation_finished(name):
	match name:
		"SETUP":
			$AnimationPlayer.play("open_main_menu")
		"open_main_menu":
			$AnimationPlayer.play("main_menu")
		"config_to_main_menu":
			$AnimationPlayer.play("open_main_menu")
		"credits_to_main_menu":
			$AnimationPlayer.play("open_main_menu")
		"level_select_to_main_menu":
			$AnimationPlayer.play("open_main_menu")
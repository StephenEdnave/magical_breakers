extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("SETUP")
	
	$CanvasLayer/Credits.setup(self)
	$CanvasLayer/Config.setup(self)
	$CanvasLayer/StartMenu.setup(self)
	$CanvasLayer/LevelSelect.setup(self)
	$CanvasLayer/LevelConfirmScreen.setup(self)
	$CanvasLayer/ExitPanel.setup(self)


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
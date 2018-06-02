extends Node2D

onready var MainMenu = "res://menus/main_menu/MainMenu.tscn"


func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("SETUP")
	
	$Container/MenuItems/MainMenuButton.connect("button_down", self, "_on_MainMenuButton_button_down")
	
	setup()


func setup():
	$Container/MenuItems/CharacterLabel.text = GameManager.player_character
	$Container/MenuItems/LevelLabel.text = GameManager.level_name


func _on_MainMenuButton_button_down():
	$Tween.interpolate_property($Music, "volume_db", $Music.volume_db, -100.0, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	$ButtonPress.play()
	$AnimationPlayer.play("exit")


func change_main_menu():
	get_tree().change_scene(MainMenu)


func _on_animation_finished(name):
	match name:
		"SETUP":
			$AnimationPlayer.play("enter")
		"enter":
			$AnimationPlayer.play("idle")
		"exit":
			change_main_menu()
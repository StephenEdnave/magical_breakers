extends Node2D

onready var MainMenu = "res://menus/main_menu/MainMenu.tscn"


func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("enter")
	
	$Container/MenuItems/MainMenuButton.connect("button_down", self, "_on_MainMenuButton_button_down")
	
	setup()


func setup():
	$Container/MenuItems/CharacterLabel.text = "Star Breaker"
	$Container/MenuItems/LevelLabel.text = "the level"


func _on_MainMenuButton_button_down():
	$Tween.interpolate_property($Music, "volume_db", $Music.volume_db, -100.0, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	$AnimationPlayer.play("exit")


func change_main_menu():
	get_tree().change_scene(MainMenu)


func _on_animation_finished(name):
	match name:
		"enter":
			$AnimationPlayer.play("idle")
		"exit":
			change_main_menu()
extends Node2D

var host = null


func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("SETUP")


func setup(_host):
	if not _host.target:
		queue_free()
		return
	
	$LockOnSound.play()
	$AnimationPlayer.play("enter")
	
	host = _host
	host.connect("lock_on", self, "exit")


func _process(delta):
	if not $AnimationPlayer.current_animation == "exit":
		global_position = host.target_position


func exit():
	host.disconnect("lock_on", self, "exit")
	$AnimationPlayer.play("exit")
	set_as_toplevel(true)
	global_position = host.target_position


func _on_animation_finished(name):
	match name:
		"enter":
			$AnimationPlayer.play("idle")
		"exit":
			queue_free()
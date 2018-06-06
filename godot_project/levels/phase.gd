extends Node2D

signal phase_ended

export (float) var wait_time = 1.0
export (float) var wave_duration = 10.0

var children = 0

func _ready():
	$SpawnTimer.wait_time = wait_time
	$SpawnTimer.connect("timeout", self, "phase_wave")
	$EndTimer.wait_time = wave_duration
	$EndTimer.connect("timeout", self, "end_phase")


func start_phase():
#	$EndTimer.start()
	for spawn_point in $SpawnPositions.get_children():
		var new_object = spawn_point.spawn($Children)
		new_object.connect("died", self, "_on_child_died")
	children = $Children.get_child_count()


func end_phase():
	emit_signal("phase_ended")
	for child in $Children.get_children():
		child.end_phase()


func _on_child_died():
	children -= 1
	if children == 0:
		end_phase()
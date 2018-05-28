extends Node2D

signal wave_ended

export (float) var wait_time = 1.0
export (float) var wave_duration = 10.0

var children = 0

func _ready():
	$SpawnTimer.wait_time = wait_time
	$SpawnTimer.connect("timeout", self, "start_wave")
	$EndTimer.wait_time = wave_duration
	$EndTimer.connect("timeout", self, "end_wave")


func start_wave():
#	$EndTimer.start()
	for spawn_point in $SpawnPositions.get_children():
		var new_object = spawn_point.spawn($Children)
		new_object.connect("died", self, "_on_child_died")
	children = $Children.get_child_count()


func end_wave():
	emit_signal("wave_ended")
	print("dank")
	for child in $Children.get_children():
		child.end_wave()


func _on_child_died():
	children -= 1
	if children == 0:
		end_wave()
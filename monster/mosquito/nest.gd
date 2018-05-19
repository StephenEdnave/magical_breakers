extends Node2D

var mosquito_scene = preload('Mosquito.tscn')
export (int) var MAX_MOSQUITO_COUNT = 2
var mosquitos = 0


func _ready():
	randomize()
	$Timer.wait_time = randf() * 1.5 + 1.0


func _on_Timer_timeout():
	if mosquitos < MAX_MOSQUITO_COUNT:
		spawn_mosquito()


func spawn_mosquito():
	var new_mosquito = mosquito_scene.instance()
	new_mosquito.global_position = calculate_random_spawn_position()
	new_mosquito.connect("died", self, "_on_mosquito_died")
	$Mosquitos.add_child(new_mosquito)
	mosquitos += 1


func calculate_random_spawn_position():
	var center_position = $SpawnCircle.global_position
	var shape_radius = $SpawnCircle.shape.radius
	
	randomize()
	var random_radius = randf() * shape_radius
	randomize()
	var random_angle = randf() * 2.0 * PI 
	
	var random_position = Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)
	return random_position + center_position


func _on_mosquito_died():
	mosquitos -= 1
extends Area2D

var direction = Vector2()
export (float) var initial_speed = 1600
var velocity = Vector2()
var speed = 600
export (float) var  acceleration = 100


func set_direction(_direction):
	direction = _direction
	velocity = direction * initial_speed
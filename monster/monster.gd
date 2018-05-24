# Base steering functions for monsters to use for movement
extends KinematicBody2D

signal health_changed
signal died

var current_state = null

onready var Anim = $AnimationPlayer
onready var Tween = $Tween

export(float) var ARRIVE_DISTANCE = 6.0
export(float) var DEFAULT_SLOW_RADIUS = 200.0
export(float) var DEFAULT_MAX_SPEED = 300.0
export(float) var MASS = 8.0

var velocity = Vector2()
var has_target = false
var target_position = Vector2()
var last_move_direction = Vector2(1, 0)
var look_direction

var start_position = Vector2()
var original_scale = Vector2()


func _ready():
	if Engine.editor_hint:
		set_physics_process(false)
		return
	
	Anim.connect('animation_finished', self, '_on_animation_finished')
	
	start_position = global_position
	original_scale = scale
	
	var target = get_tree().get_root().get_node('Level/YSort/Player')
	if not target:
		return
	target_position = target.global_position
	target.connect('position_changed', self, '_on_target_position_changed')
	target.connect('died', self, '_on_target_died')
	has_target = true
	
	$Health.connect("health_changed", self, "_on_Health_health_changed")
	$Health.connect("status_changed", self, "_on_Health_status_changed")


func follow(velocity, target_position, max_speed):
	var desired_velocity = (target_position - global_position).normalized() * max_speed

	var push = calculate_avoid_force(desired_velocity)
	var steering = (desired_velocity - velocity + push) / MASS

	return velocity + steering


func arrive_to(velocity, target_position, slow_radius=DEFAULT_SLOW_RADIUS, max_speed=DEFAULT_MAX_SPEED, avoid=false):
	var distance_to_target = position.distance_to(target_position)

	var desired_velocity = (target_position - global_position).normalized() * max_speed
	if distance_to_target < slow_radius:
		desired_velocity *= (distance_to_target / slow_radius) * .75 + .25

	var push = calculate_avoid_force(desired_velocity) if avoid else Vector2()
	var steering = (desired_velocity - velocity + push) / MASS

	return velocity + steering


func calculate_avoid_force(desired_velocity):
	$RayCast2D.cast_to = desired_velocity.normalized() * 200
	$RayCast2D.force_raycast_update()
	var push = Vector2()
	if $RayCast2D.is_colliding():
		var normal = $RayCast2D.get_collision_normal()
		var point = $RayCast2D.get_collision_point()
		push = normal.rotated(PI/2) * 300 * (1 - position.distance_to(point) / 200)
	return push


func _on_target_position_changed(new_position):
	target_position = new_position


func move(velocity):
	last_move_direction.x = sign(velocity.x)
	move_and_slide(velocity)


func _on_target_died():
	target_position = Vector2()
	has_target = false


func take_damage(source, attack_name):
	if self.is_a_parent_of(source):
		return
	$Health.take_damage(attack_name)


func _on_Health_health_changed(new_health, knockback):
	emit_signal("health_changed", new_health)


func _on_Health_status_changed(new_status):
	$StatusPivot/StatusIcon.change_status(new_status)


func end_wave():
	pass
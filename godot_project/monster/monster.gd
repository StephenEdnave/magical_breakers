# Base steering functions for monsters to use for movement
extends KinematicBody2D

signal health_changed
signal died

var states_stack = []

onready var Anim = $AnimationPlayer
onready var Tween = $Tween

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


func end_phase():
	pass
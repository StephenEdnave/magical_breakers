extends "res://objects/projectiles/projectile.gd"

signal successful_hit

const INITIAL_SPEED = 1000
var stuck_body
var weakref_stuck_body
var velocity = Vector2()
var acceleration = 0
var steering_acceleration = 40
var target_position = Vector2()
var stick_offset = Vector2()


func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("movement")
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	$ExplosionTimer.connect("timeout", self, "_on_ExplosionTimer_timeout")
	$AccelerationTimer.connect("timeout", self, "_on_AccelerationTimer_timeout")


func _physics_process(delta):
	if stuck_body:
		if not weakref_stuck_body.get_ref():
			return
		position = stuck_body.position + stick_offset
		return
	
	rotation_degrees = rad2deg(velocity.angle())
	if target_position:
		direction = (target_position - global_position).normalized()
		var desired_velocity = direction * velocity.length()
		var steering_velocity = (desired_velocity - velocity).normalized() * steering_acceleration
		velocity += steering_velocity
	velocity += velocity.normalized() * acceleration
	position += velocity * delta


func set_target(_target_position):
	target_position = _target_position


func set_direction(_direction):
	direction = _direction
	velocity = direction * INITIAL_SPEED


func _on_body_entered(body):
	if stuck_body:
		return
	
	if body.is_in_group("monsters"):
		stuck_body = body
		weakref_stuck_body = weakref(stuck_body)
		stuck_body.connect("died", self, "_on_stuck_body_died")
		stick_offset = position - stuck_body.position
		$AnimationPlayer.play("stick")


func _on_stuck_body_died():
	stuck_body = null
	target_position = position
	velocity = Vector2()
	direction = Vector2()
	
	$Pivot/Body.visible = false
	$Explosion.emitting = true
	queue_free()


func _on_animation_finished(name):
	if name == "stick" and stuck_body:
		stuck_body.take_damage(self, "star_b_sticky_bomb")
		emit_signal("successful_hit", "star_b_sticky_bomb")
		explode()


func _on_VisibilityNotifier2D_screen_exited():
	explode()


func _on_AccelerationTimer_timeout():
	acceleration = 120


func _on_ExplosionTimer_timeout():
	queue_free()


func explode():
	$Pivot/Body.visible = false
	$Explosion.emitting = true
	$ExplosionTimer.wait_time = 4
	$ExplosionTimer.start()
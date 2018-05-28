extends Area2D

const DPS = 100
const LASER_LENGTH = 4000
var current_laser_length = 2000
var max_rotation_angle = 17
var clockwise = false
var laser_tick_Time = 0.1

func _ready():
	current_laser_length = LASER_LENGTH / scale.x
	$LaserTick.connect("timeout", self, "_on_LaserTick_timeout")
	$LaserTick.wait_time = laser_tick_Time
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("spawn")
	$HitParticles.emitting = false
	$LaserStart.emitting = false
	$LaserStart2.emitting = false
	$LaserEnd.emitting = false
	$LaserEnd2.emitting = false
	$RayCast2D.cast_to = $RayCast2D.cast_to.normalized() * current_laser_length
	$Line2D.points[1] = ($Line2D.points[1] - $Line2D.points[0]).normalized() * current_laser_length
	
	var damage = DPS * $LaserTick.wait_time
	Attacks.attacks["star_b_drone_laser"].damage = damage
#	$HitParticles.set_as_toplevel(true)


func _physics_process(delta):
	if clockwise:
		rotation_degrees += max_rotation_angle * $Timer.wait_time * delta
	else:
		rotation_degrees -= max_rotation_angle * $Timer.wait_time * delta


func set_direction(direction):
	rotation_degrees = rad2deg(direction.angle())


func _on_LaserTick_timeout():
	if not $RayCast2D.is_colliding():
		$HitParticles.emitting = false
		$LaserEnd.emitting = false
		$LaserEnd2.emitting = false
		current_laser_length = LASER_LENGTH
		$Line2D.points[1] = ($Line2D.points[1] - $Line2D.points[0]).normalized() * current_laser_length
		return
	
	var collider = $RayCast2D.get_collider()
	if not collider:
		return
	var shape_check = collider.has_node("CollisionShape2D") and not collider.get_node("CollisionShape2D").disabled
	var polygon_check = collider.has_node("CollisionPolygon2D") and not collider.get_node("CollisionPolygon2D").disabled
	if not (shape_check or polygon_check):
		return
	var collider_distance = (collider.global_position - global_position).length()
	if collider.has_method("take_damage"):
		collider.take_damage(self, "star_b_drone_laser")
	
	# Particles
	current_laser_length = max(collider_distance, 1)
	$Line2D.points[1] = ($Line2D.points[1] - $Line2D.points[0]).normalized() * current_laser_length
	$HitParticles.position = $Line2D.points[1]
	$LaserStart.position = $Line2D.points[0]
	$LaserStart2.position = $Line2D.points[0]
	$LaserEnd.position = $Line2D.points[1]
	$LaserEnd2.position = $Line2D.points[1]
	$HitParticles.emitting = true
	$LaserEnd.emitting = true
	$LaserEnd2.emitting = true


func _on_Timer_timeout():
	$LaserTick.stop()
	$RayCast2D.enabled = false
	$Line2D.visible = false
	$HitParticles.emitting = false
	$LaserStart.emitting = false
	$LaserStart2.emitting = false
	$LaserEnd.emitting = false
	$LaserEnd2.emitting = false
	set_physics_process(false)
	$AnimationPlayer.play("die")


func _on_animation_finished(name):
	if name == "spawn":
		$Timer.start()
	if name == "die":
		queue_free()

func _on_SpawnAudio_finished():
	$SpawnAudio.stop()

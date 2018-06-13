extends 'on_ground.gd'

signal projectile_grazed

export (float) var MAX_DASH_SPEED = 1100
export (float) var MIN_DASH_SPEED = 600
var speed = 0.0
var acceleration = 70

export (float) var particles_per_second = 6
const DashParticles = preload("res://characters/player/star_breaker/DashParticles.tscn")
var spawn_position = Vector2()
var spawn_angle = 0
var particle_timer

var begin = true
var begin_timer = null
export (float) var BEGIN_DURATION = 0.1
export (float) var BEGIN_SPEED = 1400

var successful_dash = true # Check for if player is holding down dash button when this state is entered

func _ready():
	particle_timer = Timer.new()
	add_child(particle_timer)
	particle_timer.one_shot = false
	particle_timer.wait_time = 1 / float(particles_per_second)
	particle_timer.connect("timeout", self, "_on_particle_timer_timeout")
	
	begin_timer = Timer.new()
	add_child(begin_timer)
	begin_timer.one_shot = true
	begin_timer.wait_time = BEGIN_DURATION
	begin_timer.connect("timeout", self, "_on_begin_timer_timeout")


func enter():
	successful_dash = true
	if not Input.is_action_pressed("dash"):
		successful_dash = false
		exit()
	
	host.Anim.play("dash_forward")
	
	get_input_direction()
	velocity = input_direction * speed
	
	particle_timer.start()
	
	begin = true
	speed = BEGIN_SPEED
	begin_timer.start()
	
	# Initialize dash
	get_input_direction()
	var angle = rad2deg(input_direction.angle())
	if angle < -90 or 90 < angle: # host facing left
		angle -= 180
	spawn_angle = angle
	spawn_position = host.global_position
	host.get_node("BodyPivot").rotation_degrees = angle
	host.get_node("DashSound").play()
	_on_particle_timer_timeout()


func exit():
	host.get_node("BodyPivot").rotation_degrees = 0
	host.STATES[WALK].velocity = velocity
	particle_timer.stop()
	begin_timer.stop()


func handle_input(event):
	return .handle_input(event)


func update(delta):
	# Input
	if not successful_dash:
		return WALK
	if not begin and (host.is_player and not Input.is_action_pressed("dash")):
		return WALK
	
	get_input_direction()
	if not input_direction:
		input_direction = last_move_direction
	
	# Steering
	steering(speed, acceleration)
	if velocity.length() < MAX_DASH_SPEED:
		velocity = velocity.normalized() * MAX_DASH_SPEED
	move()
	
	
	var angle = rad2deg(velocity.angle())
	if angle < -90 or 90 < angle: # host facing left
		angle -= 180
	spawn_angle = angle
	spawn_position = host.global_position
	host.get_node("BodyPivot").rotation_degrees = angle
	
	if host.target:
		var vector_to_target = host.target_position - host.global_position
		if sign(vector_to_target.x) == sign(velocity.x):
			if host.Anim.assigned_animation != "dash_forward":
				host.Anim.play("dash_forward")
		elif sign(vector_to_target.x) != sign(velocity.x):
			if host.Anim.assigned_animation != "dash_backward":
				host.Anim.play("dash_backward")
	else:
		if host.Anim.assigned_animation != "dash_forward":
			host.Anim.play("dash_forward")


func _on_particle_timer_timeout():
	var dash_particle = DashParticles.instance()
	get_tree().get_root().add_child(dash_particle)
	dash_particle.connect("projectile_grazed", self, "_on_projectile_grazed")
	dash_particle.position = spawn_position
	dash_particle.rotation_degrees = spawn_angle


func _on_projectile_grazed():
	emit_signal("projectile_grazed")


func _on_begin_timer_timeout():
	begin = false
	speed = MAX_DASH_SPEED
extends 'motion.gd'

export(float) var CHARGE_MAX_DISTANCE = 1000.0
export(float) var max_charge_speed = 1000.0
var start_position = Vector2()
var charge_direction = Vector2()
var speed = 0
var max_charge_duration

var timeout = false
var timer

var hit_objects = []

var dps_tick_timer
var dps_tick = true

var dps_window_timer
var dps_window = true


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	max_charge_duration = CHARGE_MAX_DISTANCE / max_charge_speed
	timer.wait_time = max_charge_duration
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)
	
	dps_tick_timer = Timer.new()
	dps_tick_timer.one_shot = false
	dps_tick_timer.wait_time = 0.06
	dps_tick_timer.connect("timeout", self, "_on_dps_tick_timeout")
	add_child(dps_tick_timer)
	
	dps_window_timer = Timer.new()
	dps_window_timer.one_shot = true
	dps_window_timer.wait_time = 0.5
	dps_window_timer.connect("timeout", self, "_on_dps_window_timeout")
	add_child(dps_window_timer)
	
	._ready()


func setup(_start_position):
	start_position = _start_position


func enter(host):
	host.Anim.play("charge")
	
	# Update sprite direction
	charge_direction = (host.target_position - start_position).normalized()
	var look_direction = sign(charge_direction.x)
	host.get_node("BodyPivot").scale.x = look_direction
	var angle = rad2deg(atan2(charge_direction.y, charge_direction.x * look_direction))
	host.get_node("BodyPivot").get_node("Body").rotation_degrees = angle
	
	speed = max_charge_speed
	host.get_node("Tween").interpolate_method(self, "_deccelerate", max_charge_speed, 0, max_charge_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	host.get_node("Tween").start()
	
	host.get_node("ChargeParticles").emitting = true
	host.get_node("ChargeParticles").rotation_degrees = rad2deg(charge_direction.angle())
	
	host.get_node("ChargeStart").play()
	
	timer.start()
	
	dps_tick_timer.start()
	dps_tick = true
	
	dps_window_timer.start()
	dps_window = true


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("ChargeParticles").emitting = false
	host.get_node("BodyPivot").get_node("Body").rotation_degrees = 0
	timer.stop()
	timeout = false
	
	dps_tick_timer.stop()
	hit_objects = []


func handle_input(host, event):
	pass


func _deccelerate(progress):
	speed = progress
	if speed == 0:
		_on_timeout()


func update(host, delta):
	if timeout:
		return CHARGE_COOLDOWN
	
	velocity = charge_direction * speed
	move(host)
	
	if not dps_window or not dps_tick:
		return
	if host.get_slide_count():
		var body = host.get_slide_collision(0)
#		if body.collider_id in hit_objects:
#			return
#		hit_objects.append(body.collider_id)
		body.collider.take_damage(host, "dwarf_charge")
		host.get_node("ChargeImpact").play()
		dps_tick = false


func _on_dps_tick_timeout():
	dps_tick = true


func _on_dps_window_timeout():
	dps_window = false


func _on_timeout():
	timeout = true
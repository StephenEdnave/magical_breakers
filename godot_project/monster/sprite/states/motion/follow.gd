extends 'motion.gd'

export(float) var CHARGE_RANGE = 300.0
export(float) var FOLLOW_RANGE = 650.0
export(float) var max_follow_speed = 320.0
export(float) var SHOOT_RANGE = 600.0
export(float) var SHOOT_TIME = 2.0

export(float) var TARGET_RADIUS = 500.0
var shoot_timer = null
var go_to_shoot = false

var circle_angle = 0.0
var circle_radius = 500.0
var angle_increment = 5

func _ready():
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	shoot_timer.wait_time = SHOOT_TIME
	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")
	add_child(shoot_timer)

# Initialize the state. E.g. change the animation
func enter(host):
	host.Anim.play("walk")
	go_to_shoot = false
	shoot_timer.start()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	if not host.has_target:
		return RETURN
	
	if go_to_shoot:
		host.STATES[SHOOT].velocity = velocity
		return SHOOT
	
	var circle_position = Vector2(cos(deg2rad(circle_angle)), sin(deg2rad(circle_angle))) * circle_radius
	circle_angle += angle_increment
	if abs(circle_angle) > 360:
		circle_angle = 0
		randomize()
		if randf() < 0.5:
			angle_increment *= - 1
	
	var target_position = host.target_position
	target_position += (host.global_position - host.target_position - circle_position / 2).normalized() * TARGET_RADIUS
	target_position += circle_position
	
	velocity = follow(host, velocity, target_position, max_follow_speed)
	move(host)
	host.get_node("BodyPivot").scale.x = look_direction.x
	if host.global_position.distance_to(host.target_position) > FOLLOW_RANGE:
		return RETURN


func _on_shoot_timer_timeout():
	go_to_shoot = true
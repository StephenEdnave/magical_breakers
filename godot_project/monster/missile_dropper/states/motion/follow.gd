extends 'motion.gd'

export(float) var FOLLOW_RANGE = 650.0
export(float) var max_follow_speed = 320.0

export(float) var TARGET_RADIUS = 500.0
export(float) var DROP_RADIUS = 200.0

var shoot_timer = null
var go_to_shoot = false

func _ready():
	pass

# Initialize the state. E.g. change the animation
func enter(host):
	host.Anim.play("walk")
	go_to_shoot = false


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	if not host.has_target:
		return RETURN
	
	
	var movement_target = host.target_position + Vector2(0, -TARGET_RADIUS)
	
	velocity = follow(host, velocity, movement_target, max_follow_speed)
	move(host)
	host.get_node("BodyPivot").scale.x = look_direction.x
	
	if host.global_position.distance_to(movement_target) < DROP_RADIUS:
		host.STATES[SHOOT].velocity = velocity
		return SHOOT
	
	if host.global_position.distance_to(host.target_position) > FOLLOW_RANGE:
		return RETURN
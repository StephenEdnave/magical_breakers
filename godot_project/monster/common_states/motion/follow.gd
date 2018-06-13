extends 'motion.gd'

export(float) var FOLLOW_RANGE = 3000.0
export(float) var max_follow_speed = 320.0
export(float) var SHOOT_RANGE = 800.0
export(float) var SHOOT_TIME = 2.0
export(float) var DISTANCE_FROM_TARGET = 500.0

var shoot_timer = null
var go_to_shoot = false

var target_position = Vector2()

func _ready():
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	shoot_timer.wait_time = SHOOT_TIME
	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")
	add_child(shoot_timer)

# Initialize the state. E.g. change the animation
func enter():
	host.Anim.play("walk")
	go_to_shoot = false
	shoot_timer.start()


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func update(delta):
	if not host.has_target:
		return host.STATE_IDS.RETURN
	
	if go_to_shoot:
		return host.STATE_IDS.ATTACK
	
	target_position = host.target_position + (host.global_position - host.target_position).normalized() * DISTANCE_FROM_TARGET
	velocity = follow(velocity, target_position, max_follow_speed)
	move()
	host.get_node("BodyPivot").scale.x = look_direction.x
	if host.global_position.distance_to(host.target_position) > FOLLOW_RANGE:
		return host.STATE_IDS.RETURN


func _on_shoot_timer_timeout():
	if host.global_position.distance_to(target_position) < SHOOT_RANGE:
		go_to_shoot = true
	else:
		shoot_timer.start()
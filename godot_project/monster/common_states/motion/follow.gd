extends 'motion.gd'

export(float) var FOLLOW_RANGE = 3000.0
export(float) var SHOOT_RANGE = 800.0
export(float) var SHOOT_TIME = 2.0
export(float) var DISTANCE_FROM_TARGET = 500.0
export(float) var STOP_DISTANCE = 6.0

var shoot_timer = null
var go_to_shoot = false

func _ready():
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	shoot_timer.wait_time = SHOOT_TIME
	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")
	add_child(shoot_timer)

# Initialize the state. E.g. change the animation
func enter():
	owner.Anim.play("move_forward")
	go_to_shoot = false
	shoot_timer.start()


# Clean up the state. Reinitialize values like a timer
func exit():
	pass


func update(delta):
	if not owner.has_target:
		return owner.STATE_IDS.RETURN
	
	if go_to_shoot:
		return owner.STATE_IDS.ATTACK
	
	target_position = owner.target_position + (owner.global_position - owner.target_position).normalized() * DISTANCE_FROM_TARGET
	if owner.global_position.distance_to(target_position) < STOP_DISTANCE:
		if not owner.Anim.current_animation == "idle":
			owner.Anim.play("idle")
		return
	velocity = follow(velocity, target_position, MAX_SPEED)
	move()
	
	if sign(look_direction.x) == sign(velocity.x):
		if not owner.Anim.current_animation == "move_forward":
			owner.Anim.play("move_forward")
	else:
		if not owner.Anim.current_animation == "move_backward":
			owner.Anim.play("move_backward")
	
	if owner.global_position.distance_to(owner.target_position) > FOLLOW_RANGE:
		return owner.STATE_IDS.RETURN


func _on_shoot_timer_timeout():
	if owner.global_position.distance_to(target_position) < SHOOT_RANGE:
		go_to_shoot = true
	else:
		shoot_timer.start()
extends "../state.gd"

var input_direction = Vector2()
var last_move_direction = Vector2(1, 0)
var velocity = Vector2()

func get_input_direction():
	if not owner.is_player:
		return Vector2()
	
	input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction


func steering(speed, acceleration):
	var target_velocity = input_direction.normalized() * speed
	var steering_velocity = (target_velocity - velocity).normalized() * acceleration 
	velocity += steering_velocity
	var velocity_difference = velocity - target_velocity
	var STEERING_THRESHOLD = acceleration + 1 # acceleration + 1 so that velocity never overtakes the threshold
	if velocity_difference.length() < STEERING_THRESHOLD:
		velocity = target_velocity


func move():
	last_move_direction = input_direction
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if velocity:
		owner.position_changed()
	update_look_direction()


func update_look_direction():
	if owner.target:
		var vector_to_target = owner.target.global_position - owner.global_position
		owner.look_direction.x = sign(vector_to_target.x)
	elif last_move_direction.x != 0:
		owner.look_direction.x = last_move_direction.x
	owner.get_node("BodyPivot").scale = Vector2(owner.look_direction.x, 1)
	owner.get_node("WeaponPivot").scale = Vector2(owner.look_direction.x, 1)
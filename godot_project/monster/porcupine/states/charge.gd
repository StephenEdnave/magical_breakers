extends 'state.gd'

export(float) var CHARGE_MAX_DISTANCE = 500
export(float) var max_charge_speed = 666.0
var start_position = Vector2()
var charge_direction = Vector2()


func setup(_start_position):
	start_position = _start_position


func enter(host):
	charge_direction = (host.target_position - start_position).normalized()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	pass


func handle_input(host, event):
	pass


func update(host, delta):
	host.velocity = charge_direction * max_charge_speed
	host.move_and_slide(host.velocity)
	if host.get_slide_count() > 0: # Hit a collider
		var body = host.get_slide_collision(0).collider
		if body.get_name() == "Player":
			body.take_damage(host, 3, GlobalConstants.HEALTH_EFFECT.NONE, GlobalConstants.HEALTH_DAMAGE_TYPE.NONE, 10.0)
			return BUMP
		elif body.is_in_group('character'):
			return BUMP
	if host.position.distance_to(start_position) > CHARGE_MAX_DISTANCE:
		return CHARGE_COOLDOWN
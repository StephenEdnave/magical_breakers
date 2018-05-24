extends "../state.gd"

var last_move_direction = Vector2(1, 0)
var velocity = Vector2()
var look_direction = Vector2()


func move(host):
	last_move_direction = Vector2(sign(velocity.x), sign(velocity.y))
	host.move_and_slide(velocity, Vector2(), 5, 2)
	update_look_direction(host)


func update_look_direction(host):
	if last_move_direction.x != 0:
		look_direction.x = last_move_direction.x
	if last_move_direction.y != 0:
		look_direction.y = last_move_direction.y
	host.get_node("BodyPivot").scale = Vector2(look_direction.x, 1)
#	host.get_node("WeaponPivot").scale = Vector2(look_direction.x, 1)
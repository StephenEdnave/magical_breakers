extends "../character.gd"

signal lock_on

var target = null
var target_position = Vector2()
onready var TargetReticle = preload("res://objects/miscellaneous/crosshairs/TargetReticle.tscn")
var target_reticle = null

enum LOCK_ON_STATES { INACTIVE, ACTIVE }
var lock_on_state = INACTIVE

func _ready():
	is_player = true
	
	$States/Dash.connect("projectile_grazed", self, "_on_projectile_grazed")


func _process(delta):
	if target:
		target_position = target.global_position


func _input(event):
	if event.is_action_pressed("lock_on"):
		_change_lock_on_state()


func _change_lock_on_state():
	emit_signal("lock_on")
	if target:
		target.disconnect("died", self, "_on_target_disconnect")
	
	target = find_closest_enemy()
	if not target:
		target_position = Vector2()
		return
	target.connect("died", self, "_on_target_disconnect")
	target_position = target.global_position
	
	target_reticle = TargetReticle.instance()
	add_child(target_reticle)
	target_reticle.setup(self)


func find_closest_enemy():
	if get_tree().get_nodes_in_group("monsters").size() == 0:
		return null
	
	var monsters = get_tree().get_nodes_in_group("monsters")
	var minimum_distance = global_position.distance_to(monsters[0].global_position)
	var closest_enemy = monsters[0]
	for enemy in get_tree().get_nodes_in_group("monsters"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < minimum_distance:
			minimum_distance = distance
			closest_enemy = enemy
	
	return closest_enemy


func _on_target_disconnect():
	_change_lock_on_state()


func _on_projectile_grazed():
	pass
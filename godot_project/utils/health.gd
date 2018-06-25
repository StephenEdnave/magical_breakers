extends Node

signal health_changed
signal status_changed

var health = 0
export(int) var max_health = 1000

var status = null

var poison_cycles = 0
var max_poison_cycles = 4

var fire_cycles = 0
var max_fire_cycles = 3

var hit_pause_timer

func _ready():
	health = max_health
	$PoisonTimer.connect("timeout", self, "_on_PoisonTimer_timeout")
	$FireTimer.connect("timeout", self, "_on_FireTimer_timeout")
	$HitPauseTimer.pause_mode = Node.PAUSE_MODE_PROCESS
	$HitPauseTimer.connect("timeout", self, "_on_HitPauseTimer_timeout")
	_change_status(GlobalConstants.HEALTH_STATUS.NORMAL)


func _change_status(new_status):
	# Death takes precedence over regular status effects
	if new_status == GlobalConstants.HEALTH_STATUS.DEAD:
		$PoisonTimer.stop()
		$FireTimer.stop()
		status = new_status
		emit_signal("status_changed", new_status)
		return
	
	# Don't change status if there is a current one active
	match status:
		GlobalConstants.HEALTH_STATUS.POISON:
			if not $PoisonTimer.is_stopped():
				return
		GlobalConstants.HEALTH_STATUS.FIRE:
			if not $FireTimer.is_stopped():
				return
	
	# Enter status
	match new_status:
		GlobalConstants.HEALTH_STATUS.POISON:
			poison_cycles = 0
			$PoisonTimer.start()
		GlobalConstants.HEALTH_STATUS.FIRE:
			fire_cycles = 0
			$FireTimer.start()
	
	status = new_status
	emit_signal("status_changed", new_status)


func take_damage(attack_name):
	if status == GlobalConstants.HEALTH_STATUS.INVINCIBLE:
		return
	
	health -= Attacks.attacks[attack_name].damage
	if health < 0:
		health = 0
	var knockback = true
	if not Attacks.attacks[attack_name].has("knockback_force") and not Attacks.attacks[attack_name].has("knockback_duration"):
		knockback = false
	emit_signal("health_changed", health, knockback)
	#print("%s took %s damage. Health: %s/%s" %[get_path(), Attacks.attacks[attack_name].damage, health, max_health])
	
	if health == 0:
		_change_status(GlobalConstants.HEALTH_STATUS.DEAD)
		return
	
	var new_status
	match Attacks.attacks[attack_name].effect:
		GlobalConstants.HEALTH_EFFECT.NONE:
			new_status = GlobalConstants.HEALTH_STATUS.NORMAL
		GlobalConstants.HEALTH_EFFECT.FIRE:
			new_status = GlobalConstants.HEALTH_STATUS.FIRE
		GlobalConstants.HEALTH_EFFECT.POISON:
			new_status = GlobalConstants.HEALTH_STATUS.POISON
	_change_status(new_status)
	
	# Mana
	if get_parent().has_node("Mana"):
		get_parent().get_node("Mana").check_effect(Attacks.attacks[attack_name].mana_effect)
	
	# Hit pause
	if not Attacks.attacks[attack_name].has("hit_pause"):
		return
	var hit_pause = Attacks.attacks[attack_name].hit_pause
	$HitPauseTimer.wait_time = hit_pause
	$HitPauseTimer.start()
	get_tree().paused = true


func recover_health(attack_name):
	health += Attacks.attacks[attack_name].damage
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health)
	#print("%s recovered %s health. Health: %s/%s" %[get_path(), Attacks.attacks[attack_name].damage, health, max_health])


func _on_PoisonTimer_timeout():
	if poison_cycles >= max_poison_cycles:
		$PoisonTimer.stop()
		_change_status(GlobalConstants.HEALTH_STATUS.NORMAL)
		return
	
	take_damage("poison")
	poison_cycles += 1


func _on_FireTimer_timeout():
	if fire_cycles >= max_fire_cycles:
		$FireTimer.stop()
		_change_status(GlobalConstants.HEALTH_STATUS.NORMAL)
		return
	
	take_damage("burn")
	fire_cycles += 1


func _on_HitPauseTimer_timeout():
	get_tree().paused = false
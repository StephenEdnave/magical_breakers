extends Node

signal health_changed
signal status_changed

var health = 0
export(int) var max_health = 1000

var status = null

var poison_cycles = 0
var max_poison_cycles = 2

var burn_cycles = 0
var max_burn_cycles = 1

var hit_pause_timer

func _ready():
	health = max_health
	$PoisonTimer.connect("timeout", self, "_on_PoisonTimer_timeout")
	$BurnTimer.connect("timeout", self, "_on_BurnTimer_timeout")
	$HitPauseTimer.pause_mode = Node.PAUSE_MODE_PROCESS
	$HitPauseTimer.connect("timeout", self, "_on_HitPauseTimer_timeout")
	_change_status(GlobalConstants.HEALTH_STATUS.NONE)


func _change_status(new_status):
	emit_signal("status_changed", status, new_status)
	# Exit status
	match status:
		GlobalConstants.HEALTH_STATUS.POISONED:
			$PoisonTimer.stop()
		GlobalConstants.HEALTH_STATUS.BURNED:
			$BurnTimer.stop()
	
	# Enter status
	match new_status:
		GlobalConstants.HEALTH_STATUS.POISONED:
			poison_cycles = 0
			$PoisonTimer.start()
		GlobalConstants.HEALTH_STATUS.BURNED:
			burn_cycles = 0
			$BurnTimer.start()
	
	status = new_status


func take_damage(attack_name):
	if status == GlobalConstants.HEALTH_STATUS.INVINCIBLE:
		return
	
	health -= Attacks.attacks[attack_name].damage
	if health < 0:
		health = 0
	var knockback = true
	if Attacks.attacks[attack_name].damage_type == GlobalConstants.HEALTH_DAMAGE_TYPE.POISON:
		knockback = false
	emit_signal("health_changed", health, knockback)
	print("%s took %s damage. Health: %s/%s" %[get_path(), Attacks.attacks[attack_name].damage, health, max_health])
	
	if health == 0:
		_change_status(GlobalConstants.HEALTH_STATUS.DEAD)
		return
	
	match Attacks.attacks[attack_name].effect:
		GlobalConstants.HEALTH_EFFECT.POISON:
			_change_status(GlobalConstants.HEALTH_STATUS.POISONED)
		GlobalConstants.HEALTH_EFFECT.BURN:
			_change_status(GlobalConstants.HEALTH_STATUS.BURNED)
	
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
	print("%s recovered %s health. Health: %s/%s" %[get_path(), Attacks.attacks[attack_name].damage, health, max_health])


func _on_PoisonTimer_timeout():
	if poison_cycles >= max_poison_cycles:
		_change_status(GlobalConstants.HEALTH_STATUS.NONE)
		return
	
	take_damage("poison")
	poison_cycles += 1


func _on_BurnTimer_timeout():
	if burn_cycles >= max_burn_cycles:
		_change_status(GlobalConstants.HEALTH_STATUS.NONE)
		return
	
	take_damage("burn")
	burn_cycles += 1


func _on_HitPauseTimer_timeout():
	get_tree().paused = false
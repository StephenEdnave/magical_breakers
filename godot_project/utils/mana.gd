extends Node

signal mana_changed
signal status_changed

var mana = 0
export(int) var max_mana = 300

var status = null

var drain_cycles = 0
var max_drain_cycles = 3


func _ready():
	mana = 0
	$DrainTimer.connect("timeout", self, "_on_DrainTimer_timeout")
	$ManaRegenTimer.connect("timeout", self, "_on_ManaRegenTimer_timeout")
	_change_status(GlobalConstants.MANA_STATUS.NORMAL)


func _change_status(new_status):
	# Don't change status if there is a current one active
	match status:
		GlobalConstants.MANA_STATUS.DRAIN:
			if not $DrainTimer.is_stopped():
				return
	
	# Enter status
	match new_status:
		GlobalConstants.MANA_STATUS.DRAIN:
			drain_cycles = 0
			$DrainTimer.start()
	
	status = new_status
	emit_signal("status_changed", new_status)


func expend_mana(cost):
	if status == GlobalConstants.MANA_STATUS.NO_COST:
		return
	
	mana -= cost
	if mana < 0:
		mana = 0
	emit_signal("mana_changed", mana)


func recover_mana(mana_gain):
	mana += mana_gain
	if mana > max_mana:
		mana = max_mana
	emit_signal("mana_changed", mana)


func check_effect(mana_effect):
	var new_status
	match mana_effect:
		GlobalConstants.MANA_EFFECT.NONE:
			new_status = GlobalConstants.MANA_STATUS.NORMAL
		GlobalConstants.MANA_EFFECT.DRAIN:
			new_status = GlobalConstants.MANA_STATUS.DRAIN
	_change_status(new_status)


func _on_DrainTimer_timeout():
	if drain_cycles >= max_drain_cycles:
		$DrainTimer.stop()
		_change_status(GlobalConstants.HEALTH_STATUS.NONE)
		return
	
	expend_mana(Attacks.attacks["drain"].mana_damage)
	drain_cycles += 1


func _on_ManaRegenTimer_timeout():
	recover_mana(1)
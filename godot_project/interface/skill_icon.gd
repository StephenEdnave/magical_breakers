extends CenterContainer

var cooldown = 0
var cost = 0
var disabled = true

var player = null


func setup(_player, skill_id):
	player = _player
	var weapon_id = skill_id + 2 - 1 # +2 because the first two weapons are not skill weapons; -1 because actual index is -1 because gdscript starts arrays at 0
	cost = player.STATES[player.STATE_IDS.ATTACK].weapons[weapon_id].costs[0]
	$ControlPivot/ControlLabel.text = InputMap.get_action_list("skill_" + str(skill_id))[0].as_text()


func _ready():
	$CooldownTimer.connect("timeout", self, "_on_CooldownTimer_timeout")


func start_cooldown(_cooldown):
	cooldown = _cooldown
	$CooldownTimer.start()
	$CooldownLabel.text = str(cooldown)
	$CooldownLabel.visible = true
	disable_skill()


func check_mana(mana):
	if not disabled and mana < cost :
		disable_skill()
	elif disabled and mana >= cost and $CooldownTimer.is_stopped():
		enable_skill()


func disable_skill():
	disabled = true
	$Icon.modulate.r = 0.4
	$Icon.modulate.g = 0.2
	$Icon.modulate.b = 0.4


func enable_skill():
	disabled = false
	$Icon.modulate.r = 1
	$Icon.modulate.g = 1
	$Icon.modulate.b = 1
	$CooldownAudio.play()


func end_cooldown():
	$CooldownLabel.visible = false
	$CooldownTimer.stop()
	check_mana(player.get_node("Mana").mana)


func _on_CooldownTimer_timeout():
	cooldown -= 1
	if cooldown > 0:
		$CooldownLabel.text = str(cooldown)
	else:
		end_cooldown()
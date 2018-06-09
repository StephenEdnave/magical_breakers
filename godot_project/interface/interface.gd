extends Control


var player_max_health = 1
var player_max_mana = 1


func setup(player):
	player.connect("health_changed", self, "_on_player_health_changed")
	player_max_health = player.get_node("Health").max_health
	_on_player_health_changed(player.get_node("Health").health)
	
	player.connect("mana_changed", self, "_on_player_mana_changed")
	player_max_mana = player.get_node("Mana").max_mana
	_on_player_mana_changed(player.get_node("Mana").mana)
	
	player.connect("skill_used", self, "player_skill_used")
	for i in range(0, 4):
		$SkillIcons.get_child(i).setup(player, i + 1)


func player_skill_used(skill_id, cooldown):
	$SkillIcons.get_child(skill_id - 1).start_cooldown(cooldown)


func _on_player_health_changed(health):
	$Bars/HealthBar/TextureProgress.value = float(health) / float(player_max_health) * 100
	$Bars/HealthBar/Counter/Label.text = str(float(health)) +" / " + str(float(player_max_health))


func _on_player_mana_changed(mana):
	$Bars/ManaBar/TextureProgress.value = float(mana) / float(player_max_mana) * 100
	$Bars/ManaBar/Counter/Label.text = str(float(mana)) +" / " + str(float(player_max_mana))
	for i in range(0, 4):
		$SkillIcons.get_child(i).check_mana(mana)
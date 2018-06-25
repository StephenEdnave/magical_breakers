extends "res://utils/states/state.gd"


func _ready():
	GameManager.level.connect("cutscene_finished", self, "draw_weapon")


func enter():
	owner.Anim.play("idle")


func exit():
	return


func update(delta):
	return owner.STATE_IDS.ROAM_SEQUENCE


func _on_animation_finished(anim_name):
	if anim_name == "draw_weapon":
		return owner.STATE_IDS.ROAM_SEQUENCE


func draw_weapon():
	owner.Anim.play("draw_weapon")
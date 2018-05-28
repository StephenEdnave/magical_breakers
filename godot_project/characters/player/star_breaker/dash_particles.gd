extends Area2D

signal projectile_grazed

func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Particle.emitting = true


func _on_body_entered(body):
	emit_signal("projectile_grazed")


func _on_Timer_timeout():
	queue_free()
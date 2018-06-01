extends "res://objects/projectiles/projectile.gd"

const INITIAL_SPEED = 1600
var velocity = Vector2()
var speed = 800
var acceleration = -100


func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	$ExplosionTimer.connect("timeout", self, "_on_ExplosionTimer_timeout")
	$ExplosionTimer.wait_time = $Explosion.lifetime


func _physics_process(delta):
	position += velocity * delta


func set_direction(_direction):
	direction = _direction
	velocity = direction * speed


func _on_body_entered(body):
	if body.is_in_group("player"):
		explode(body)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func explode(body):
	$Explosion.emitting = true
	$ExplosionSFX.play()
	body.take_damage(self, "basic_plushy_projectile")
	$ExplosionTimer.start()
	$AnimationPlayer.play("explosion")
	$CollisionShape2D.disabled = true


func _on_ExplosionTimer_timeout():
	queue_free()
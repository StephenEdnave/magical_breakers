extends "res://objects/projectiles/projectile.gd"

const INITIAL_SPEED = 1600
var velocity = Vector2()
var speed = 800
var acceleration = -100
var exploded = false

func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	exploded = false


func _physics_process(delta):
	velocity += velocity.normalized() * acceleration
	if velocity.length() < speed:
		velocity = velocity.normalized() * speed
	position += velocity * delta


func set_direction(_direction):
	direction = _direction
	velocity = direction * INITIAL_SPEED


func _on_body_entered(body):
	if body.is_in_group("player"):
		explode(body)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func explode(body):
	if not exploded:
		$Pivot/Body.visible = false
		$Explosion.emitting = true
		$ExplosionSFX.play()
		body.take_damage(self, "dwarf_projectile_explosion")
	body.take_damage(self, "dwarf_projectile_energy")
	exploded = true


func take_damage(source, name):
	if not exploded:
		$Pivot/Body.visible = false
		$Explosion.emitting = true
		$ExplosionSFX.play()
extends Area2D

@export var speed := 900.0
@export var lifetime := 3.0
var velocity := Vector2.ZERO

func setup(dir: Vector2):
	velocity = dir.normalized() * speed
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()

extends CharacterBody2D

@export var speed := 25.0             # movement speed
@export var shoot_cooldown := 1.6      # seconds between shots
@export var projectile_scene : PackedScene

var timer := 0.0

@onready var player := get_tree().get_first_node_in_group("player")

func _ready():
	timer = randf() * shoot_cooldown

func _physics_process(delta):
	if player == null:
		return
	
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	
	timer -= delta
	if timer <= 0:
		shoot(dir)
		timer = shoot_cooldown

func shoot(direction: Vector2):
	if projectile_scene == null:
		return

	var proj = projectile_scene.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = global_position
	proj.setup(direction)

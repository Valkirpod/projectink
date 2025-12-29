extends CharacterBody2D

@export var cooldown_time := 2.0       # time before charging
@export var windup_time := 0.3         # time showing the charge direction
@export var dash_speed := 1600.0        # speed of the dash
@export var dash_distance := 900.0     # how far the dash goes if not stopped by wallsa

@export var dash_time := 2.0              # how long its allowed to dash, in case of no collisions or not reaching target
# need this cuz im using bad collision check...

var state := "cooldown"
var timer := 0.0
var dash_dir := Vector2.ZERO
var dash_remaining := 0.0

@onready var player := get_tree().get_first_node_in_group("player")
@onready var line := $Line2D
@onready var hurtbox := $Hurtbox/CollisionShape2D

func _ready():
	line.visible = false
	start_cooldown()
	timer = randf_range(0, cooldown_time)

func _physics_process(delta):
	match state:
		"cooldown":
			timer -= delta
			if timer <= 0:
				start_windup()
				
		"windup":
			timer -= delta
			if timer <= 0:
				start_dash()
				
		"dash":
			do_dash(delta)
			timer -= delta
			if timer <= 0:
				start_cooldown()

func start_cooldown():
	state = "cooldown"
	timer = cooldown_time
	velocity = Vector2.ZERO
	line.visible = false

func start_windup():
	if player == null:
		start_cooldown()
		return
		
	state = "windup"
	timer = windup_time
	
	dash_dir = (player.global_position - global_position).normalized()
	dash_remaining = dash_distance
	
	line.visible = true
	update_windup_line()

func update_windup_line():
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(dash_dir * dash_distance)

func start_dash():
	state = "dash"
	timer = dash_time
	line.visible = false
	velocity = dash_dir * dash_speed

func do_dash(delta):
	if state != "dash":
		return
		
	var before = global_position
	var collision = move_and_collide(dash_dir * dash_speed * delta)
	var traveled = before.distance_to(global_position)
	dash_remaining -= traveled
	
	if collision:
		if collision.get_collider().is_in_group("wall"):
			start_cooldown()
		elif collision.get_collider().is_in_group("player"):
			get_tree().reload_current_scene()
		return
		
	if dash_remaining <= 0:
		start_cooldown()

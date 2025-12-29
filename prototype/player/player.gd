extends CharacterBody2D

@export var speed := 900.0

@export var dash_speed := 2400.0
@export var dash_duration := 0.12
@export var dash_cooldown := 0.4

var is_dashing := false
var invincible := false #for jumping over obstacles
var dash_timer := 0.0
var cooldown_timer := 0.0
var dash_direction := Vector2.ZERO


func _physics_process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
		
	if is_dashing:
		dash_timer -= delta
		
		velocity = dash_direction * dash_speed
		move_and_slide()
		
		if dash_timer <= 0:
			end_dash()
		return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
	
	velocity = input_vector * speed
	
	if Input.is_action_just_pressed("dash"):
		try_start_dash(input_vector)
	
	move_and_slide()


func try_start_dash(input_vector: Vector2) -> void:
	if cooldown_timer > 0:
		return
	if input_vector == Vector2.ZERO:
		return 
	
	is_dashing = true
	invincible = true
	dash_timer = dash_duration
	dash_direction = input_vector.normalized()
	
	
func end_dash() -> void:
	is_dashing = false
	invincible = false
	cooldown_timer = dash_cooldown
	

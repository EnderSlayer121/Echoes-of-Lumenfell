extends CharacterBody2D
@export_category("Movement Variables")
@export var move_speed = 120.0
@export var deceleration = 0.1
@export var gravity = 500.0
var movement = Vector2()

@export_category("Jumping Variables")
@export var jump_height = 190.0
@export var jump_acceleration = 290.0
@export var jump_amount = 2

@export_category("Wall Jumping Variables")
@export var wall_slide = 40
@onready var right_ray: RayCast2D = $RayCast/right_ray
@export var wall_x_force = 200.0
@export var wall_y_force = -220.0
var is_wall_jumping = false

@export_category("Dashing Variables")
@export var dash_speed = 400.0
@export var facing_right = true
@export var dash_gravity = 0
@export var dash_number = 1
var dash_key_pressed = 0
var is_dashing = false
var dash_timer = Timer

@export_category("Sword Slashing Variables")
@export var is_attacking = false


func _ready() -> void:
	$"sword hitbox/sword_collider".disabled = true

func _physics_process(delta: float) -> void:
	if !is_dashing:
		velocity.y += gravity * delta
	elif is_dashing:
		velocity.y = dash_gravity
	ground_movement()
	jumping()
	wall_jumping()
	set_animations()
	flip()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("slash"):
		is_attacking = true

func ground_movement():
	if is_wall_jumping == false and !is_dashing:
		movement = Input.get_axis("left", "right")
		if movement:
			velocity.x = movement * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed * deceleration)
	if Input.is_action_just_pressed("dash") and dash_key_pressed == 0 and dash_number >= 1:
		dash_number -= 1
		dash_key_pressed = 1
		dash()

func set_animations():
	if !is_attacking:
		$AnimationPlayer.speed_scale = 1.0
		if velocity.x != 0:
			$AnimationPlayer.play("walk")
		if velocity.x == 0:
			$AnimationPlayer.play("idle")
		if velocity.y < 0:
			$AnimationPlayer.play("jump")
		if velocity.y > 10:
			$AnimationPlayer.play("fall")
		if is_on_wall_only() == true:
			$AnimationPlayer.play("slide")
	if is_attacking:
		$AnimationPlayer.speed_scale = 2.5
		$AnimationPlayer.play("attack_forward")

func flip():
	if velocity.x > 0:
		facing_right = true
		scale.x = scale.y * 1
		wall_x_force = 200.0
	if velocity.x < 0:
		facing_right = false
		scale.x = scale.y * -1
		wall_x_force = -200.0

func jumping():
	if is_on_floor():
		jump_amount = 2
		dash_number = 1
		if Input.is_action_just_pressed("jump"):
			jump_amount -= 1
			velocity.y -= lerp(jump_height, jump_acceleration, 0.1)
	elif not is_on_floor() and jump_amount > 0:
		if Input.is_action_just_pressed("jump"):
			jump_amount -= 1
			velocity.y -= lerp(jump_height, jump_acceleration, 1)
		elif Input.is_action_just_released("jump"):
			velocity.y = lerp(velocity.y, gravity, 0.2)
			velocity.y *= 0.3
	else:
		return

func wall_jumping():
	if is_on_wall_only():
		velocity.y = wall_slide
		if Input.is_action_just_pressed("jump") and right_ray.is_colliding():
			jump_amount = 2
			velocity = Vector2(-wall_x_force, wall_y_force)
			wall_jumping_in_progress()

func wall_jumping_in_progress():
	is_wall_jumping = true
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false

func dash():
	if dash_key_pressed == 1:
		is_dashing = true
	else:
		is_dashing = false
	if facing_right:
		velocity.x = dash_speed
		dash_in_progress()
	elif !facing_right:
		velocity.x = -dash_speed
		dash_in_progress()

func dash_in_progress():
	if is_dashing == true:
		dash_key_pressed = 1
		await get_tree().create_timer(0.3).timeout
		is_dashing = false
		dash_key_pressed = 0
	else:
		return

func reset_states():
	is_attacking = false

extends Camera2D

@onready var crossroads_ground: TileMapLayer = $"../CrossroadsGround"
@onready var greenpath_ground: TileMapLayer = $"../GreenpathGround"
@onready var kingdom_ground: TileMapLayer = $"../KingdomGround"
@onready var wanderer: Node2D = $"../Wanderer/CharacterBody2D"

@export var horizontal_dead_zone = 30
@export var vertical_dead_zone = 30
@export var follow_speed = 120.0 #Needs to be equal to player speed

func _ready() -> void:
	set_camera_limits()

func _physics_process(delta: float) -> void:
	set_camera_limits()
	follow_player(delta)

func set_camera_limits():
	global_position = wanderer.global_position
	var used_rect = crossroads_ground.get_used_rect()
	var cell_size = crossroads_ground.tile_set.tile_size
	var map_width = used_rect.size.x * cell_size.x
	var map_height = used_rect.size.y * cell_size.y
	
	limit_left = used_rect.position.x * cell_size.x
	limit_right = limit_left + map_width
	limit_top = used_rect.position.y * cell_size.y
	limit_bottom = limit_top + map_height

func follow_player(delta):
	if not wanderer:
		return
	var player_pos = wanderer.global_position
	var camera_pos = global_position
	var viewport_size = get_viewport_rect().size / zoom
	#Calculate Where Player is
	var target_pos = camera_pos
	
	if Main.is_loading:
		global_position = Main.player_position
	
	#horizontal movement
	if abs(player_pos.x - camera_pos.x) > horizontal_dead_zone:
		if wanderer.is_dashing == true:
			follow_speed = 400.0 #camera follows quicker when dashing
		elif wanderer.is_dashing == false:
			follow_speed = 120.0
		target_pos.x = player_pos.x
	
	#vertical movement
	if Main.is_loading == true:
		target_pos.y = Main.player_position.y
		position.y = move_toward(position.y, target_pos.y, follow_speed * delta)
	elif player_pos.y < camera_pos.y - vertical_dead_zone:
		target_pos.y = player_pos.y
	elif player_pos.y > camera_pos.y + vertical_dead_zone:
		target_pos.y = player_pos.y
	
	#smoother movement
	position.x = move_toward(position.x, target_pos.x, follow_speed * delta)
	
	
	#when wanderer falling
	if player_pos.y > camera_pos.y:
		position.y = move_toward(position.y, target_pos.y, wanderer.velocity.y * delta)
	else: #normal y smoother movement
		position.y = move_toward(position.y, target_pos.y, follow_speed * delta)

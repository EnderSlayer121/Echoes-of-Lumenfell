extends Node2D

func _ready() -> void:
	if !Main.is_loading:
		Main.health = 4
		Main.soul = 0.0

func _process(delta: float) -> void:
	if Main.health <= -1:
		Main.game_over_1()

func on_game_data_loaded(data: Dictionary):
	var player_node = find_child("Wanderer")
	if player_node:
		var saved_pos_x = data.get("player_position_x", 0.0)
		var saved_pos_y = data.get("player_position_y", -20.0)
		player_node.global_position = Vector2(saved_pos_x, saved_pos_y)
		print("Wanderer position updated from save data.")
	else:
		print("Error: Wanderer node not found in the current scene to apply data.")

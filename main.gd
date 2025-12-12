extends Node2D

@export var health = 4
@export var soul = 0.0
var player_position: Vector2 = Vector2(0, -20)
var camera_position: Vector2 = player_position
const SAVE_PATH = "res://EchoesofLumenfellsaves/game_save.dat"
var is_loading = false

func get_current_scene():
	var path = get_tree().current_scene.scene_file_path
	if path.is_empty():
		print("WARNING: current scene no file path")
	return path

func game_over():
	var scene = get_current_scene()
	if scene == "res://levels/level_3.tscn":
		get_tree().change_scene_to_file("res://UI/fail3.tscn")
	elif scene == "res://levels/level_2.tscn" or "res://levels/level_2_2.tscn":
		get_tree().change_scene_to_file("res://UI/fail2.tscn")
	elif scene == "res://levels/level_master.tscn" or "res://levels/level_master_2.tscn":
		get_tree().change_scene_to_file("res://UI/fail.tscn")

func save_game():
	var current_scene = get_current_scene()
	var save_dict = {
		"health": health,
		"soul": soul,
		"player_position_x": player_position.x,
		"player_position_y": player_position.y,
		"current_scene": current_scene
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		print("Failed to open file for saving: ", FileAccess.get_open_error())
		return

	# Store the dictionary as a single variable
	file.store_var(save_dict)
	file.close()
	print("Game Saved")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		return false
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		print("Failed to open file for loading: ", FileAccess.get_open_error())
		return false
	is_loading = true
	# Read the data back into a dictionary
	var save_dict = file.get_var()
	file.close()
	
	#Open correct scene
	var last_scene = save_dict.get("current_scene", "")
	if last_scene.is_empty():
		print("Error: Save file did not contain a valid scene path.")
		is_loading = false
		return false
	
	var load_scene = get_tree().change_scene_to_file(last_scene)
	if load_scene != OK:
		print("Error changing scene to: ", last_scene, " Error code: ", load_scene)
		is_loading = false
		return false
	await get_tree().scene_changed
	# Repopulate the global variables
	health = save_dict.get("health", 4)
	soul = save_dict.get("soul", 0.0)
	player_position.x = save_dict.get("player_position_x", 0)
	player_position.y = save_dict.get("player_position_y", -20)
	if get_tree().current_scene.has_method("on_game_data_loaded"):
		get_tree().current_scene.on_game_data_loaded(save_dict)
	else:
		print("Warning: New scene root node does not have on_game_data_loaded method.")

	print("Game Loaded")
	return true

func delete_save():
	if FileAccess.file_exists(SAVE_PATH):
		var dir = DirAccess.open("res://EchoesofLumenfellsaves/game_save.dat")
		if dir:
			# Remove the file using DirAccess.remove()
			var error = dir.remove(SAVE_PATH)
			if error == OK:
				print("Save file deleted successfully: ", SAVE_PATH)
			else:
				print("Failed to delete save file. Error code: ", error)
		else:
			print("Failed to open user:// directory")
	else:
		print("Save file not found: ", SAVE_PATH)

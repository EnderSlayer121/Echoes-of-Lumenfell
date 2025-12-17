extends Node2D

@export var health = 4
@export var soul = 0.0
var player_position: Vector2 = Vector2(0, -20)
var camera_position: Vector2 = player_position
var is_loading = false

func get_current_scene():
	var path = get_tree().current_scene.scene_file_path
	if path.is_empty():
		print("WARNING: current scene no file path")
	else:
		print(path)
	return path

func game_over_1():
	get_tree().change_scene_to_file("res://UI/fail.tscn")
	print("loading first fail")

func game_over_2():
	get_tree().change_scene_to_file("res://UI/fail2.tscn")
	print("loading 2nd fail")

func game_over_3():
	get_tree().change_scene_to_file("res://UI/fail3.tscn")
	print("Loading 3rd fail")

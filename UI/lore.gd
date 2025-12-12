extends CanvasLayer

@onready var new_button = $Button

func _ready() -> void:
	new_button.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_master.tscn")

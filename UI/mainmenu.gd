extends CanvasLayer

@onready var new_button = $"New Game"

func _ready() -> void:
	$AnimationPlayer.play("new_animation")
	if $Button:
		$Button.grab_focus()
	else:
		new_button.grab_focus()

func _process(delta: float) -> void:
	await $AudioStreamPlayer.finished
	$AudioStreamPlayer.play()

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/lore.tscn")

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/controls.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/mainmenuvictored.tscn")

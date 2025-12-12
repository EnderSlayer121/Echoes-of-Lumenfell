extends CanvasLayer

func _ready() -> void:
	$Load.grab_focus()
	while $Sprite2D.frame < 151:
		$Timer.start()
		await $Timer.timeout
		$Sprite2D.frame += 1

func _on_load_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_2.tscn")
	
	

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_master.tscn")

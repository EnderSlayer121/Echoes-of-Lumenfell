extends PathFollow2D

@export var speed = 0.2

func _process(delta: float) -> void:
	progress_ratio += speed * delta
	if progress_ratio >= 0.5:
		$Fly/Sprite2D.flip_v = true
	elif progress_ratio >= 0:
		$Fly/Sprite2D.flip_v = false

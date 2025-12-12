extends Resource
class_name playersaves

@export var move_speed = 120.0
@export var health = 4
@export var soul = 0.0
@export var savepos : Vector2

func update_pos(value : Vector2):
	savepos = value

func update_health(value : int):
	health += value

func update_soul(value : float):
	soul += value

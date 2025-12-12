extends CharacterBody2D

@export var health = 2
@export var damage = 1.0

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		health -= 1
		if Main.soul <= 1.0:
			Main.soul += 0.25
	if area.is_in_group("Fireball"):
		health -= 2


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Main.health -= damage
		Timer.new()

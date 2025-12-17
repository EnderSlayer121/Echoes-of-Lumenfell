extends CharacterBody2D

@export var health = 2
@export var damage = 1.0

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword") and $hitbyPlayer.is_stopped():
		health -= 1
		$hitbyPlayer.start()
		$Sprite2D.self_modulate = "ffffff7d"
		$hitbox/CollisionShape2D.disabled = true
		$enemyhurt.play()
		if Main.soul < 1.0:
			Main.soul += 0.25
		await $hitbyPlayer.timeout
		$Sprite2D.self_modulate = "ffffff"
		$hitbox/CollisionShape2D.disabled = false
	if area.is_in_group("Fireball") and $hitbyPlayer.is_stopped():
		health -= 2
		$hitbyPlayer.start()
		$Sprite2D.self_modulate = "ffffff7d"
		$hitbox/CollisionShape2D.disabled = true
		$enemyhurt.play()
		await $hitbyPlayer.timeout
		$Sprite2D.self_modulate = "ffffff"
		$hitbox/CollisionShape2D.disabled = false
	if area.is_in_group("Player") and $hitPlayer.is_stopped():
		Main.health -= damage
		$hitPlayer.start()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and $hitPlayer.is_stopped() and $hitbyPlayer.is_stopped():
		Main.health -= damage
		$hitPlayer.start()

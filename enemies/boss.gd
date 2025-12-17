extends CharacterBody2D

@export var health = 25
@export var damage = 2.0
var enemyspeed = -100
var gravity: float = 500.0
var facing_right = false

func _physics_process(delta: float) -> void:
	if not is_on_floor(): #Check if on solid ground
		velocity.y += gravity * delta
	if $Sprite2D/RayCast2D.is_colliding() or $Sprite2D/RayCast2D3.is_colliding():
		flip()
	if !$Sprite2D/RayCast2D2.is_colliding() or !$Sprite2D/RayCast2D4.is_colliding():
		flip()
	velocity.x = enemyspeed
	if health <= 0:
		get_tree().change_scene_to_file("res://UI/victory.tscn")
	move_and_slide()

func flip():
	facing_right = !facing_right
	$Sprite2D.flip_h = !$Sprite2D.flip_h
	$Sprite2D.offset.x = -$Sprite2D.offset.x
	if facing_right:
		enemyspeed = abs(enemyspeed)
	else:
		enemyspeed = abs(enemyspeed) * -1

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		health -= 1
		$hitbyPlayer.start()
		$Sprite2D.self_modulate = "ffffff7d"
		$enemyhurt.play()
		if Main.soul < 1.0:
			Main.soul += 0.25
		await $hitbyPlayer.timeout
		$Sprite2D.self_modulate = "ffffff"
	if area.is_in_group("Fireball"):
		health -= 2
		$hitbyPlayer.start()
		$Sprite2D.self_modulate = "ffffff7d"
		$enemyhurt.play()
		await $hitbyPlayer.timeout
		$Sprite2D.self_modulate = "ffffff"

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Main.health -= damage
		$hitPlayer.start()

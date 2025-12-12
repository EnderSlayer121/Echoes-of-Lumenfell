extends CharacterBody2D

@export var health = 6
@export var damage = 1.0
var enemyspeed = -50
var gravity: float = 500.0
var facing_right = false

func _physics_process(delta: float) -> void:
	if not is_on_floor(): #Check if on solid ground
		velocity.y += gravity * delta
	if $Sprite2D/RayCast2D.is_colliding() or $Sprite2D/RayCast2D3.is_colliding() or $Sprite2D/RayCast2D5.is_colliding() or $Sprite2D/RayCast2D6.is_colliding():
		flip()
	if !$Sprite2D/RayCast2D2.is_colliding() or !$Sprite2D/RayCast2D4.is_colliding():
		flip()
	velocity.x = enemyspeed
	if health <= 0:
		queue_free()
	move_and_slide()

func flip():
	facing_right = !facing_right
	$Sprite2D.flip_h = !$Sprite2D.flip_h
	$Sprite2D.offset.x = -$Sprite2D.offset.x + 2
	if facing_right:
		enemyspeed = abs(enemyspeed)
		$Sprite2D.offset.x = 4.0
	else:
		enemyspeed = abs(enemyspeed) * -1
		$Sprite2D.offset.x = 2.0

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		health -= 1
		if Main.soul <= 1.0:
			Main.soul += 0.25
	if area.is_in_group("Fireball"):
		health -= 3

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Main.health -= damage

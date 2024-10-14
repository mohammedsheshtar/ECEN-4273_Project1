extends Node2D

const bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

func _on_player_shoot(pos, dir):
	var bullet = bullet_scene.instantiate()
	var direction = 1 if dir else -1
	bullet.direction = direction
	$bullets.add_child(bullet)
	bullet.position = pos + Vector2(16 * direction,0)

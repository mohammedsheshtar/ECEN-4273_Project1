extends Area2D

@onready var timer: Timer = $Timer
@onready var player = get_tree().get_first_node_in_group('player')
func _on_body_entered(body):
	if body.is_in_group("player"):
		var player = body
		player.set_animation_to_death()
		print("YOU Died!")
		player.set_health_zero()

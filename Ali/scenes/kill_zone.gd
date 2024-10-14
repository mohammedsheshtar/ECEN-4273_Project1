extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body):
	print("YOU Died!")
	timer.start()
	

func _on_timer_timeout():
	get_tree().reload_current_scene()

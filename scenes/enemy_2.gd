extends Area2D


var health := 4


func _on_area_entered(area: Area2D) -> void:
	health -= 1
	print('doggo was hit')
	area.queue_free()
	var tween = create_tween()
	#tween.tween_property(self, 'position', Vector2(100, 200), 1)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)

func _process(delta):
	check_death()

func check_death():
	if health <= 0:
		queue_free()
extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")



func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/options_menu.tscn")

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/controls_menu.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
	

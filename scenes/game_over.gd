extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/start_menu.tscn")

func game_over():
	get_tree().paused = true
	self.show

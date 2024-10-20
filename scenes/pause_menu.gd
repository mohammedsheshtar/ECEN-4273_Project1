extends CanvasLayer
func _ready() -> void:
	self.hide()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().paused = true
			self.show()

func _on_back_pressed() -> void:
	get_tree().paused = false
	self.hide()


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(-40,40)



func _on_mute_toggled(toggled_on: bool) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, !AudioServer.is_bus_mute(master_bus_index))
	
func _on_display_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))

func _on_quit_pressed() -> void:
	get_tree().quit()

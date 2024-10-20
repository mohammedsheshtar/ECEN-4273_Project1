extends Node

var current_form := 0  # 0: Morning, 1: Afternoon, 2: Night
var form_durations := [30, 30, 30]  # Duration for each form in seconds
var elapsed_time := 0

# Background nodes (as Sprite2D)
@onready var clouds_morning = $CanvasLayer/ColorRect/Clouds_Morning
@onready var town_morning = $CanvasLayer/ColorRect/Town_Morning
@onready var clouds_afternoon = $CanvasLayer/ColorRect/Clouds_Afternoon
@onready var town_afternoon = $CanvasLayer/ColorRect/Town_Afternoon
@onready var clouds_night = $CanvasLayer/ColorRect/Clouds_Night
@onready var town_night = $CanvasLayer/ColorRect/Town_Night

func _ready() -> void:
	set_background(current_form)
	start_timer()

func _process(delta):
	# Check if the background needs to change based on elapsed time
	if elapsed_time >= form_durations[current_form]:
		transition_to_next_form()

func start_timer():
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_tick"))
	add_child(timer)
	timer.start()

func _on_timer_tick():
	elapsed_time += 1

func transition_to_next_form():
	elapsed_time = 0  # Reset elapsed time for the next form
	current_form += 1

	# Check if all forms have been completed
	if current_form >= 3:
		reset_game()  # Restart the game after the last form
	else:
		set_background(current_form)

func set_background(form_index):
	# Make all backgrounds invisible initially
	clouds_morning.visible = false
	town_morning.visible = false
	clouds_afternoon.visible = false
	town_afternoon.visible = false
	clouds_night.visible = false
	town_night.visible = false

	# Set the specific background visible based on form_index
	match form_index:
		0:  # Morning
			clouds_morning.visible = true
			town_morning.visible = true
		1:  # Afternoon
			clouds_afternoon.visible = true
			town_afternoon.visible = true
		2:  # Night
			clouds_night.visible = true
			town_night.visible = true

func reset_game():
	# Reset the game to the start menu
	print("Resetting game to start menu")
	get_tree().change_scene_to_file("res://Menus/start_menu.tscn")

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

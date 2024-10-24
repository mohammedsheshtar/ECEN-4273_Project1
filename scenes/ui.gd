extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group('player')
@onready var timer_label = $TimerLabel  # Reference the label directly from CanvasLayer

var time_left := 90.0  # Use a float for precision

func _ready():
	set_process(true)  # Enable processing

func _process(delta):
	$MarginContainer/TextureProgressBar.value = player.health
	update_timer(delta)

func update_timer(delta):
	if time_left > 0:
		time_left -= delta
		var minutes = int(time_left) / 60
		var seconds = int(time_left) % 60
		timer_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

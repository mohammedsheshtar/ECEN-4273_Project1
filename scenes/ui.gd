extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group('player')

func _process(_delta: float) -> void:
	$MarginContainer/ProgressBar.value = player.health

extends Area2D
@export var speed := 300
var direction := 1

func _ready():
	$AnimatedSprite2D.flip_h = direction < 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 300 * direction * delta

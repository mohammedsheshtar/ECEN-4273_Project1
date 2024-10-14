extends AnimatableBody2D

@export var marker1: Marker2D  # Assign the first marker in the Inspector
@export var marker2: Marker2D  # Assign the second marker in the Inspector
@export var speed = 50  # Movement speed of the platform

var target = null  # Holds the current target marker
var direction = Vector2.ZERO  # Movement direction
var forward = true  # To determine if the platform is moving forward (toward marker2)

func _ready():
	# Start by setting the target to marker2 (the end position)
	target = marker2
	position = marker1.position  # Start at marker1

func _process(delta):
	move_platform(delta)

func move_platform(delta):
	# Move the platform towards the current target (marker1 or marker2)
	position += (target.position - position).normalized() * speed * delta
	
	# Check if the platform is close to the target
	if position.distance_to(target.position) < 5:
		# Toggle between marker1 and marker2 when the platform reaches the target
		forward = not forward
		target = marker2 if forward else marker1

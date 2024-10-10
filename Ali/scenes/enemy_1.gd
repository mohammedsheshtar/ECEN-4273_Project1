extends Area2D

var health := 3
var animation := ''
@export var marker1: Marker2D
@export var marker2: Marker2D
@export var speed = 25
@onready var target = marker1
var forward := true
@onready var player = get_tree().get_first_node_in_group('player')
@export var notice_radius := 80

func _on_area_entered(area: Area2D) -> void:
	health -= 1
	print('ghostie was hit')
	area.queue_free()
	var tween = create_tween()
	#tween.tween_property(self, 'position', Vector2(100, 200), 1)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)

func _ready():
	position = marker2.position

func get_target():
	if forward and position.distance_to(marker1.position) < 10 or\
	not forward and position.distance_to(marker2.position) < 10:
		forward = not forward
	if position.distance_to(player.position) < notice_radius:
		target = player
	elif forward:
		target = marker1
	else:
		target = marker2

func _process(delta):
	check_death()
	get_target()
	position += (target.position - position).normalized() * speed * delta
	flip_logic()

func flip_logic():
	$AnimatedSprite2D.flip_h = not forward
	if position.distance_to(player.position) < notice_radius:
		$AnimatedSprite2D.flip_h = position.x < player.position.x

func check_death():
	if health <= 0:
		queue_free()

func get_animation():
	pass


func _on_body_entered(body):
	if 'get_damage' in body:
		body.get_damage(10)

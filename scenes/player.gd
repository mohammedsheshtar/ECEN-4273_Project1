extends CharacterBody2D

var direction_x := 0.0
var facing_right := true
@export var speed := 150
var can_shoot := true
signal shoot(pos: Vector2, dir: bool)
var health := 100
var vulnerable := true
var animation = ''
var death = false
@onready var kill_zone = get_tree().get_first_node_in_group('Kill zone')
var alive := true
func _ready() -> void:
	pass

func _process(delta):
	if death == false:
		get_input()
	else:
		animation = 'death'
	apply_gravity(delta)
	get_facing_direction()
	get_animation()
	check_health()
	
	velocity.x = direction_x * 150 
	move_and_slide()
	
func get_input():
	if alive == false:
		return
	
	direction_x = Input.get_axis("left","right")
		
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot.emit(global_position, facing_right)
		can_shoot = false
		$timers/cooldownTimer.start()
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -150
	


func apply_gravity(delta):
	velocity.y += 400 * delta
	
func get_facing_direction():
	if direction_x != 0:
		facing_right = direction_x >= 0

func get_animation():
	animation = 'idle'
	var shot_ani = ''
	if not is_on_floor():
		animation = 'jump'
	elif direction_x != 0:
		animation = 'walk'
	elif death:
		animation = 'death'
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.flip_h = not facing_right
		


func _on_cooldown_timer_timeout() -> void:
	can_shoot = true

func get_damage(amount):
	if vulnerable:
		health -= amount
		print('layl was damaged')
		print(health)
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
		vulnerable = false
		$timers/invincibility.start() 


func _on_invincibility_timeout() -> void:
	vulnerable = true

func check_health():
	if health <= 0:
		die()

func die():
	alive = false
	print("Player has died")
	set_animation_to_death()
	get_tree().change_scene_to_file("res://Menus/start_menu.tscn")
func set_animation_to_death():
	animation = 'death'
	death = true
func set_health_zero():
	health = 0
	alive = false

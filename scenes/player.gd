extends CharacterBody2D

# Player variables
var direction_x := 0.0
var facing_right := true
var can_shoot := true
var health := 100
var vulnerable := true
var animation = ''
var death = false
var alive := true

# Form-related variables
var current_form := 0  # 0: Morning, 1: Afternoon, 2: Night
var elapsed_time := 0

# Speed for different forms
@export var speed := 150

# Nodes for sprites and collision shapes
@onready var morning_sprite = $AnimatedSprite2D_Morning
@onready var afternoon_sprite = $AnimatedSprite2D_Afternoon
@onready var night_sprite = $AnimatedSprite2D_Night

@onready var morning_collision = $CollisionShape2D_Morning
@onready var afternoon_collision = $CollisionShape2D_Afternoon
@onready var night_collision = $CollisionShape2D_Night

# Timer for form change
@onready var form_timer = Timer.new()

# Shooting signal
signal shoot(pos: Vector2, dir: bool)

func _ready() -> void:
	set_form(current_form)  # Set the initial form
	setup_form_timer()  # Set up the timer for form change

func _process(delta):
	if not death:
		get_input()
	else:
		animation = 'death'
	apply_gravity(delta)
	get_facing_direction()
	get_animation()
	check_health()
	
	velocity.x = direction_x * speed
	move_and_slide()

# Handle player input
func get_input():
	if not alive:
		return

	direction_x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot.emit(global_position, facing_right)
		can_shoot = false
		$timers/cooldownTimer.start()
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		match current_form:
			0:  # Morning form
				velocity.y = -150
			1:  # Afternoon form
				velocity.y = -150
			2:  # Night form
				velocity.y = -150

# Applie gravity to the player
func apply_gravity(delta):
	velocity.y += 400 * delta

# Determine the player's facing direction
func get_facing_direction():
	if direction_x != 0:
		facing_right = direction_x >= 0

# Set the player's animation based on state and form
func get_animation():
	animation = 'idle'
	if not is_on_floor():
		animation = 'jump'
	elif direction_x != 0:
		animation = 'walk'
	elif death:
		animation = 'death'
	
	update_current_sprite()

# Update the currently visible sprite based on form
func update_current_sprite():
	morning_sprite.visible = current_form == 0
	afternoon_sprite.visible = current_form == 1
	night_sprite.visible = current_form == 2

	match current_form:
		0:
			morning_sprite.animation = animation
			morning_sprite.flip_h = not facing_right
		1:
			afternoon_sprite.animation = animation
			afternoon_sprite.flip_h = facing_right
		2:
			night_sprite.animation = animation
			night_sprite.flip_h = not facing_right

# Set the form and adjusts properties accordingly
func set_form(form_index):
	current_form = form_index

	# Hide all sprites and disable all collision shapes initially
	morning_sprite.visible = false
	afternoon_sprite.visible = false
	night_sprite.visible = false

	morning_collision.disabled = true
	afternoon_collision.disabled = true
	night_collision.disabled = true

	# Set the current form's sprite and collision shape active
	match form_index:
		0:
			morning_sprite.visible = true
			morning_collision.disabled = false
			speed = 150  # Morning speed
		1:
			afternoon_sprite.visible = true
			afternoon_collision.disabled = false
			speed = 200  # Afternoon speed
		2:
			night_sprite.visible = true
			night_collision.disabled = false
			speed = 150 # Night speed

# Set up a timer to change forms every 30 seconds
func setup_form_timer():
	form_timer.wait_time = 30.0
	form_timer.one_shot = false
	form_timer.connect("timeout", Callable(self, "_on_form_timer_timeout"))  # Use Callable
	add_child(form_timer)
	form_timer.start()

# Change the form when the timer times out
func _on_form_timer_timeout():
	current_form += 1
	if current_form >= 3:
		end_game()  # End the game after the night form
	else:
		set_form(current_form)

# End the game and returns to the start menu
func end_game():
	print("Ending game - returning to start menu")
	get_tree().change_scene_to_file("res://Menus/start_menu.tscn")

# Handle cooldown for shooting
func _on_cooldown_timer_timeout() -> void:
	can_shoot = true

# Handle player taking damage and sets the damage effect on the correct sprite
func get_damage(amount):
	if vulnerable:
		health -= amount
		print('Player was damaged')
		print(health)
		
		var tween = create_tween()

		# Apply damage effect to the correct sprite based on current form
		match current_form:
			0:
				tween.tween_property(morning_sprite, "material:shader_parameter/amount", 1.0, 0.0)
				tween.tween_property(morning_sprite, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
			1:
				tween.tween_property(afternoon_sprite, "material:shader_parameter/amount", 1.0, 0.0)
				tween.tween_property(afternoon_sprite, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
			2:
				tween.tween_property(night_sprite, "material:shader_parameter/amount", 1.0, 0.0)
				tween.tween_property(night_sprite, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)

		vulnerable = false
		$timers/invincibility.start() 

# Reset vulnerability after the invincibility timer times out
func _on_invincibility_timeout() -> void:
	vulnerable = true

# Check player's health and triggers death if health reaches zero
func check_health():
	if health <= 0:
		die()

# Handle player death
func die():
	alive = false
	print("Player has died")
	await get_tree().create_timer(1).timeout
	set_animation_to_death()
	end_game()

# Set the death animation
func set_animation_to_death():
	animation = 'death'
	death = true

# Set player health to zero
func set_health_zero():
	health = 0
	alive = false

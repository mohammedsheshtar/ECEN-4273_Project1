extends Node

# Function that waits for a delay
func delayed_action(delay_time: float) -> void:
	var timer = Timer.new()
	timer.wait_time = delay_time
	timer.one_shot = true
	add_child(timer)  # Add the timer to the scene
	timer.start()

	await timer.timeout  # Wait for the timer to finish
	print("Delay finished!")  # Action after delay

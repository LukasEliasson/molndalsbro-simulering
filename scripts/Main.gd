extends Node2D

const MOVE_SPEED = 300
var multi = 1
signal set_simulation_pause(state)

func _process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right"),
		Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down")
	)
	
	if Input.is_action_pressed("shift"):
		multi = 3
	else:
		multi = 1
	
	if input_dir != Vector2.ZERO:
		emit_signal("set_simulation_pause", true)
		global_position += input_dir.normalized() * MOVE_SPEED * delta * multi
	else:
		emit_signal("set_simulation_pause", false)
		

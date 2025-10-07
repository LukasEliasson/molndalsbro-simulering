extends Node2D

const MOVE_SPEED = 300

func _process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right"),
		Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down")
	)
	
	if input_dir != Vector2.ZERO:
		global_position += input_dir.normalized() * MOVE_SPEED * delta

func _ready() -> void:
	print('Main ready')

# var npc = preload("res://scenes/Person.tscn").instantiate()

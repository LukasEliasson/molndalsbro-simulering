extends CharacterBody2D

var path: Array = []
var path_index: int = 0
var speed: int = 100

func process_move(delta: float) -> void:
	if path.is_empty():
		return
	
	var target = path[path_index]
	var direction = (target - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	if global_position.distance_to(target) < 5.0:
		path_index += 1
		if path_index >= path.size():
			queue_free()

func set_path(new_path: Array) -> void:
	path = new_path
	path_index = 0

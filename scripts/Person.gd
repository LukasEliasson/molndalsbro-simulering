extends CharacterBody2D

@export var speed: float = 100.0
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var previous_distance: float = 0.0

func _ready() -> void:
	navigation_agent.velocity_computed.connect(_on_velocity_computed)

func set_target(target: Vector2) -> void:
	navigation_agent.set_target_position(target)
	previous_distance = global_position.distance_to(target)

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		queue_free()
		return
	
	var next_position = navigation_agent.get_next_path_position()
	var desired_velocity = (next_position - global_position).normalized() * speed
	navigation_agent.set_velocity(desired_velocity)

	
	var next_pos = navigation_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	if velocity.dot(direction) < 0:
		navigation_agent.set_target_position(navigation_agent.get_target_position())

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

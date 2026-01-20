extends CharacterBody2D

@export var speed: float = 68.0
var std_dev = 0.2 # Standard devation for speed. The higher the more difference in speed between agents
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var previous_distance: float = 0.0
var current_distance: float
var path_update_timer = 0.0
const PATH_UPDATE_INTERVAL = 0.2
var has_reached_target = false
var simulation_paused = false
var target

func _ready() -> void:
	speed *= random_speed_multiplier()
	navigation_agent.velocity_computed.connect(_on_velocity_computed)

func set_target(local_target: Vector2) -> void:
	target = local_target
	navigation_agent.set_target_position(target)
	current_distance = global_position.distance_to(target)

func update_pathfinding(delta: float) -> void:
	if not simulation_paused:
		path_update_timer -= delta
		if path_update_timer <= 0.0:
			path_update_timer = PATH_UPDATE_INTERVAL
			if navigation_agent.is_navigation_finished():
				has_reached_target = true
			
			var next_position = navigation_agent.get_next_path_position()
			var desired_velocity = (next_position - global_position).normalized() * speed
			navigation_agent.set_velocity(desired_velocity)
			
			# Update path to mimic human movement
			var direction = (next_position - global_position).normalized()
			if velocity.dot(direction) < 0:
				navigation_agent.set_target_position(target)
			if velocity.length() < speed * 0.5:
				navigation_agent.set_target_position(target)
			current_distance = global_position.distance_to(target)
			if previous_distance < current_distance:
				navigation_agent.set_target_position(target)
			previous_distance = global_position.distance_to(target)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if not simulation_paused:
		velocity = safe_velocity
		move_and_slide()

func rand_normal(mean: float = 0.0, std_dev: float = 1.0) -> float:
	var u1 = randf()
	var u2 = randf()
	var z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2)
	return z0 * std_dev + mean

func random_speed_multiplier() -> float:
	var mean = 1.0
	var value = rand_normal(mean, std_dev)
	return clamp(value, 0.6, 1.4)

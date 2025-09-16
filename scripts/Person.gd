extends CharacterBody2D

var path: Array = []
var path_index: int = 0
@export var speed: float = 100.0
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
func set_target(target: Vector2) -> void:
	navigation_agent.set_target_position(target)
	
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()



func set_path(new_path: Array) -> void:
	path = new_path
	path_index = 0

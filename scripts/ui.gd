extends CanvasLayer
@export var agent_manager_path = "res://scenes/Station.tscn"
@onready var agent_manager = get_node(agent_manager_path)  # Drag your agent manager node here
@onready var label = $Label

func _ready() -> void:
	var receiver = get_node("/root/Main/Station")
	receiver.connect("set_agent_count", Callable(self, "_on_agent_count_changed"))

func _on_agent_count_changed(agent_count):
	label.text = "Agents: %d" % agent_count

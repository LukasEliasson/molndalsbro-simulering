extends CanvasLayer
@export var agent_manager_path = "res://scenes/Station.tscn"
@onready var agent_manager = get_node(agent_manager_path)  # Drag your agent manager node here
@onready var label = $Label

func _process(delta):
	print(agent_manager.get_agent_count())
	#label.text = "Agents: %d" % get_agent_count()

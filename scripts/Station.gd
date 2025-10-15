extends Node2D

@export var person_scene = preload("res://scenes/Person.tscn")
@export var spawn_interval: float = 0.1

var agents = []
var simulation_paused = false
signal set_agent_count(count)

func _ready() -> void:
	var reciever = get_node("/root/Main")
	reciever.connect("set_simulation_pause", Callable(self, "_on_set_simulation_pause"))
	spawn_person()

var spawn_cooldown = spawn_interval

func _physics_process(delta):
	if not simulation_paused:
		# Iterate backwards to safely remove agents
		for i in range(agents.size() - 1, -1, -1):
			var agent = agents[i]
			
			if not agent.has_reached_target:
				agent.update_pathfinding(delta)  # centralized update
			else:
				agent.queue_free()
				agents[i] = agents.back()  # swap-remove for efficiency
				agents.pop_back()
		
		spawn_cooldown -= delta
		if spawn_cooldown <= 0:
			spawn_person()
			spawn_cooldown = spawn_interval

func spawn_person():
	if not simulation_paused:
		var entries = $EntryPoints.get_children()
		var entry = entries.pick_random()
		var exit = entries.pick_random()
		while entry == exit:
			exit = entries.pick_random()
		
		var person = person_scene.instantiate()
		add_child(person)
		person.global_position = entry.global_position
		person.set_target(exit.global_position)
		agents.append(person)
		emit_signal("set_agent_count", agents.size())
	
func _on_set_simulation_pause(state):
	simulation_paused = state
	for i in range(agents.size()):
		agents[i].simulation_paused = state

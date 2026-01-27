extends Node2D

@export var person_scene = preload("res://scenes/Person.tscn")
@export var spawn_interval: float = 0.2

var rng = RandomNumberGenerator.new()

var agents = []
var simulation_paused = false
var config_file

var combo_points = []
var entry_points = []
var exit_points = []

var combo_weights = []
var entry_weights = []
var exit_weights = []

var possible_entries = []
var possible_exits = []
var possible_entries_weights = []
var possible_exits_weights = []

signal set_agent_count(count)

func _ready() -> void:
	var receiver = get_node("/root/Main")
	receiver.connect("set_simulation_pause", Callable(self, "_on_set_simulation_pause"))
	
	combo_points = $SpawnPoints/ComboPoints.get_children()
	entry_points = $SpawnPoints/EntryPoints.get_children()
	exit_points = $SpawnPoints/ExitPoints.get_children()
	
	possible_entries = combo_points + entry_points
	possible_exits = combo_points + exit_points
	
	set_spawn_weights()
	
	possible_entries_weights = combo_weights + entry_weights
	possible_exits_weights = combo_weights + exit_weights

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
	if not simulation_paused and agents.size() < 500:
		var entry = pick_entry_point()
		var exit = pick_exit_point()
		
		while entry == exit or (entry_points.has(entry) and exit_points.has(exit) and (entry.name.substr(entry.name.length() - 1) != exit.name.substr(exit.name.length() - 1))):
			exit = pick_exit_point()
		
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
		
func pick_entry_point():
	return (possible_entries)[rng.rand_weighted(possible_entries_weights)]
	
func pick_exit_point():
	return (possible_exits)[rng.rand_weighted(possible_exits_weights)]
		
func set_spawn_weights():
	for point in combo_points:
		combo_weights.append(config_file.get_value("Combo", point.name))
	for point in entry_points:
		entry_weights.append(config_file.get_value("Entry", point.name))
	for point in exit_points:
		exit_weights.append(config_file.get_value("Exit", point.name))

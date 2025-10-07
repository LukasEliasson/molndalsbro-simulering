extends Node2D

@export var person_scene = preload("res://scenes/Person.tscn")
@export var spawn_interval: float = 0.1

var agents = []

func _ready() -> void:
	spawn_person()

var spawn_cooldown = spawn_interval

func _physics_process(delta):
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
	var entries = $EntryPoints.get_children()
	if entries.size() < 2:
		return
	
	var entry = entries.pick_random()
	var exit = entries.pick_random()
	while entry == exit:
		exit = entries.pick_random()
	
	var person = person_scene.instantiate()
	add_child(person)
	person.global_position = entry.global_position
	person.set_target(exit.global_position)
	agents.append(person)

func get_agent_count() -> int:
	return agents.size()

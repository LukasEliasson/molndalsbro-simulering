extends Node2D

@onready var entry1 = $EntryPoints/Entry1
@onready var entry2 = $EntryPoints/Entry2
@export var person_scene = preload("res://scenes/Person.tscn")

func _ready() -> void:
	spawn_person()

func spawn_person():
	var person = person_scene.instantiate()
	add_child(person)
	person.global_position = entry1.global_position
	person.set_target(entry2.global_position)

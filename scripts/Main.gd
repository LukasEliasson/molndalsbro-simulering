extends Node2D

var station_scene = preload("res://scenes/Station.tscn")
var ui_scene = preload("res://scenes/ui.tscn")

var config = ConfigFile.new()
var err = config.load("res://config.cfg")

@onready var camera = $Camera2D
const MOVE_SPEED = 900
var multi = 1
signal set_simulation_pause(state)

func _ready():
	# If the file didn't load, create a default file
	if err != OK:
		print("Config file not found! File created with default values.")
		create_default_config()
		config.save("res://config.cfg")
	
	var station = station_scene.instantiate()
	
	station.entry_weights = config.get_value("Both", "Stairs") # TODO Identify all data
	
	add_child(station)
	var ui = ui_scene.instantiate()
	add_child(ui)
	
	camera.zoom.x = 1
	camera.zoom.y = 1

func _process(delta):
	handle_input(delta)
	

func handle_input(delta):
	var input_dir = Vector2(
		Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left"),
		Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
	)
	
	if Input.is_action_pressed("shift"):
		multi = 3
	else:
		multi = 1
		
	var zoom_speed = 4

	if Input.is_action_pressed("zoom_in"):
		if camera.zoom.x < 5:
			camera.zoom *= pow(zoom_speed, delta)
	elif Input.is_action_pressed("zoom_out"):
		if camera.zoom.x > 0.2:
			camera.zoom /= pow(zoom_speed, delta)
	
	if input_dir != Vector2.ZERO:
		emit_signal("set_simulation_pause", false)
		camera.position += input_dir.normalized() * MOVE_SPEED * delta * multi / camera.zoom.x
	else:
		emit_signal("set_simulation_pause", false)
		
func create_default_config():
	config.set_value("Both", "Stairs", "weight") # TODO Create default values

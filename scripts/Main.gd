extends Node2D

var station_scene = preload("res://scenes/Station.tscn")
var ui_scene = preload("res://scenes/ui.tscn")

var config_file = ConfigFile.new()
var err = config_file.load("res://config.cfg")

@onready var camera = $Camera2D
const MOVE_SPEED = 900
var multi = 1
signal set_simulation_pause(state)
var simulation_pause = false

func _ready():
	# If the file didn't load, create a default file
	if err != OK:
		print("Config file not found! File created with default values.")
		create_default_config()
		config_file.save("res://config.cfg")
	
	var station = station_scene.instantiate()
	station.config_file = config_file
	
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
	elif Input.is_action_just_pressed("simulation_pause"):
		if simulation_pause:
			emit_signal("set_simulation_pause", false)
			simulation_pause = false
		else:
			emit_signal("set_simulation_pause", true)
			simulation_pause = true
	
	if input_dir != Vector2.ZERO:
		camera.position += input_dir.normalized() * MOVE_SPEED * delta * multi / camera.zoom.x
		
func create_default_config():
	config_file.set_value("Combo", "Stairs1", 1.0) # TODO Create default values
	config_file.set_value("Combo", "Stairs2", 0.1)
	config_file.set_value("Combo", "Stairs3", 1.0)
	config_file.set_value("Combo", "Street1", 1.0)
	config_file.set_value("Combo", "Street2", 1.0)
	config_file.set_value("Combo", "Elevator1", 0.1)
	config_file.set_value("Combo", "Elevator2", 0.1)
	config_file.set_value("Combo", "Bus1", 0.25)
	config_file.set_value("Combo", "Bus2", 0.25)
	config_file.set_value("Combo", "Bus3", 0.25)
	config_file.set_value("Combo", "Bus4", 0.25)
	config_file.set_value("Combo", "Bus5", 0.25)
	config_file.set_value("Combo", "Bus6", 0.25)
	config_file.set_value("Combo", "Bus7", 0.25)
	config_file.set_value("Combo", "Bus8", 0.25)
	
	config_file.set_value("Entry", "Escalator1_1", 1.0)
	config_file.set_value("Entry", "Escalator2_1", 1.0)
	
	config_file.set_value("Exit", "Escalator1_2", 1.0)
	config_file.set_value("Exit", "Escalator2_2", 1.0)

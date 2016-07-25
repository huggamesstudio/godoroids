extends Node2D

func _ready():
	# State async configuration
	self.set_process(true)
	self.set_process_input(true)

	# Load and instance the player ship
	var ship_scene = load("res://scenes/entities/ship.tscn")
	var ship_instance = ship_scene.instance()
	self.add_child(ship_instance)

	# Assign the scene camera to the player ship
	var camera = self.get_node("Camera2D")
	var current_camera_parent = camera.get_parent()
	current_camera_parent.remove_child(camera)
	ship_instance.add_child(camera)

func _process(delta):
	pass

func _input(event):

	# ESC - Exits the application
	if event.is_action("ui_cancel"):
		self.get_tree().set_input_as_handled()
		self.get_tree().quit()
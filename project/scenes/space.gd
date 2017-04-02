extends Node2D

func _ready():

	# State async configuration
	set_fixed_process(true)
	set_process_input(true)

	#build_ship_scene()
	build_mothership_scene()

func _fixed_process(delta):
	pass

func _input(event):

	# ESC - Exits the application
	if event.is_action("ui_cancel"):
		get_tree().set_input_as_handled()
		get_tree().quit()

func build_ship_scene():

	# Instance a planet
	var planet_scene = load("res://scenes/entities/planet.tscn")
	var planet_instance = planet_scene.instance()
	add_child(planet_instance)

	# Load and instance the player ship
	var ship_scene = load("res://scenes/entities/ship.tscn")
	var ship_instance = ship_scene.instance()
	add_child(ship_instance)
	ship_instance.set_pos(Vector2(-300,-300))

	# Load player 1 behavior (input) into the ship
	var player1_int = load("res://scenes/modules/player1_intelligence.tscn").instance()
	ship_instance.add_child(player1_int)

	# Assign the scene camera to the player ship
	var camera = get_node("Camera2D")
	var current_camera_parent = camera.get_parent()
	current_camera_parent.remove_child(camera)
	ship_instance.add_child(camera)

func build_mothership_scene():

	# Instance a planet
	var planet_scene = load("res://scenes/entities/planet.tscn")
	var planet_instance = planet_scene.instance()
	add_child(planet_instance)
	planet_instance.set_pos(Vector2(897.35, 475.927))

	# Instance two cruisers
	var cruiser_scene = load("res://scenes/entities/cruiser.tscn")
	var cruiser_ai_module = load("res://scenes/modules/cruiser_AI.tscn")

	var cruiser1_instance = cruiser_scene.instance()
	var cruiser1_ai_instance = cruiser_ai_module.instance()
	cruiser1_instance.add_child(cruiser1_ai_instance)

	var cruiser2_instance = cruiser_scene.instance()
	var cruiser2_ai_instance = cruiser_ai_module.instance()
	cruiser2_instance.add_child(cruiser2_ai_instance)

	add_child(cruiser1_instance)
	add_child(cruiser2_instance)

	cruiser2_instance.set_pos(Vector2(1535.92, 954.271))

	# Instance a mothership
	var mothership_scene = load("res://scenes/entities/mothership.tscn")
	var player1_ai_module = load("res://scenes/modules/player1_intelligence.tscn")
	var mothership_instance = mothership_scene.instance()
	var mothership_ai_instance = player1_ai_module.instance()
	mothership_instance.add_child(mothership_ai_instance)
	add_child(mothership_instance)
	mothership_instance.set_pos(Vector2(-18.1766, 368.076))

	# Assign the scene camera to the mothership
	var camera = get_node("Camera2D")
	var current_camera_parent = camera.get_parent()
	current_camera_parent.remove_child(camera)
	mothership_instance.add_child(camera)

extends Node2D

var _hud
var _space_bodies
var _space_ships

func _ready():

	# State async configuration
	set_fixed_process(true)
	set_process_input(true)

	_hud = get_node("Hud")

#	build_gauge_scene()
	build_ship_scene()
#	build_mothership_scene()

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
	ship_instance.get_node("Team").set_team(1)

	# Load player 1 behavior (input) into the ship
	var player1_int = load("res://scenes/modules/player1_intelligence.tscn")
	ship_instance.add_child(player1_int.instance())

	# AI ship 1
	var ai_ship_instance_1 = ship_scene.instance()
	add_child(ai_ship_instance_1)
	ai_ship_instance_1.set_pos(Vector2(-250,-300))
	
	# AI ship 2
	var ai_ship_instance_2 = ship_scene.instance()
	add_child(ai_ship_instance_2)
	ai_ship_instance_2.set_pos(Vector2(-300,-250))

	# Load AI module into the ship
	var ship_ai = load("res://scenes/modules/ship_ai.tscn")
	ai_ship_instance_1.add_child(ship_ai.instance())
	ai_ship_instance_1.get_node("Team").set_team(2)
	ai_ship_instance_2.add_child(ship_ai.instance())
	ai_ship_instance_2.get_node("Team").set_team(3)

	# Assign HUD to player ship
	var camera = get_node("Camera")
	_hud.set_camera(camera)
	_hud.set_reference_actor(ship_instance)

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
	cruiser1_instance.get_node("Team")._team = 2
	cruiser1_instance.add_child(cruiser1_ai_instance)

	var cruiser2_instance = cruiser_scene.instance()
	var cruiser2_ai_instance = cruiser_ai_module.instance()
	cruiser2_instance.get_node("Team")._team = 2
	cruiser2_instance.add_child(cruiser2_ai_instance)

	add_child(cruiser1_instance)
	add_child(cruiser2_instance)

	cruiser2_instance.set_pos(Vector2(1535.92, 954.271))

	# Instance a mothership
	var mothership_scene = load("res://scenes/entities/mothership.tscn")
	var player1_ai_module = load("res://scenes/modules/player1_intelligence.tscn")
	var mothership_instance = mothership_scene.instance()
	var mothership_ai_instance = player1_ai_module.instance()
	mothership_instance.get_node("Team")._team = 1
	mothership_instance.add_child(mothership_ai_instance)
	add_child(mothership_instance)
	mothership_instance.set_pos(Vector2(-18.1766, 368.076))

	# Assign the scene camera to the mothership
	var camera = get_node("Camera")
	_hud.set_camera(camera)
	_hud.set_reference_actor(mothership_instance)

func build_gauge_scene():
	var gauge_scene = load("res://scenes/interface/gauge_4_circle.tscn")
	var gauge_instance = gauge_scene.instance()
	add_child(gauge_instance)
	gauge_instance.set_pos(Vector2(300,300))
	gauge_instance.enable_blink(true)
	gauge_instance.modulate_blink(Color(1,0,0))
	gauge_instance.set_inner_value(0.5)
	gauge_instance.set_outer_value(0.25)
	gauge_instance.modulate_inner(Color(0.95,0.95,1))
	gauge_instance.modulate_outer(Color(0,1,0))
	gauge_instance.modulate_border(Color(1,0,1))

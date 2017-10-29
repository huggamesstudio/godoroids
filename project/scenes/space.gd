extends Node2D

var _space_bodies
var _space_ships

func _ready():

	# State async configuration
	set_fixed_process(true)
	set_process_input(true)
	
	Global.camera = get_node("Camera")

#	build_gauge_scene()
	build_ship_scene()
#	build_mothership_scene()

func _fixed_process(delta):
		# Add text to debug window
	if Global.player1_ref and Global.player1_ref.get_ref():
		var player1 = Global.player1_ref.get_ref()
		if player1.has_node("Hud"):
			player1.get_node("Hud").get_node("DebugWindow").show()
			player1.get_node("Hud").get_node("DebugWindow").set_text("SCORES!\nTeam 0 score: "+str(Global.TEAM_SCORES[2])+"\nTeam 1 score: "+str(Global.TEAM_SCORES[4]))
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

	var hud = load("res://scenes/interface/hud.tscn").instance()
	mothership_instance.add_child(hud)

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

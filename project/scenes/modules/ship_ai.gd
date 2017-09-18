extends Node


# When this node is attached as child to a DynamicBody2D (KineticBody2D+dynamic_body.gd)
# allows it to be controlled by player 1.
#
# It is intended to be installed in a Ship node.
#
# Only works one at a time.


var _head
var _physics
var _systems
var _engines
var _bays
var _team

var _target_ship

func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	_systems = _head.get_node("Systems")
	_engines = _head.get_node("Engines")
	_bays = _head.get_node("Bays")
	_team = _head.get_node("Team")
	set_fixed_process(true)

func _fixed_process(delta):
	_choose_strategy()

func _choose_strategy():
	if not(_target_ship and (_head.get_pos() - _target_ship.get_pos()).length() < Global.ENGAGE_DISTANCE):
		_set_target()
		

func _set_target():
	var ships = get_tree().get_nodes_in_group("ships")
	if ships.empty():
		return
	var closest_distance
	var closest_ship
	for ship in ships:
		var target_team = Global.TEAM[0] # Neutral team
		if ship.get_node("Team") and ship.get_node("Team").has_method("get_team"):
				target_team = Global.TEAM[ship.get_node("Team").get_team()]
		if target_team == Global.TEAM[_team.get_team()]:
			continue
		
		var distance = (_head.get_pos() - ship.get_pos()).length()
		if closest_distance and closest_ship:
			if distance < closest_distance:
				closest_distance = distance
				closest_ship = ship
		else:
			closest_distance = distance
			closest_ship = ship
	
	if closest_ship:
		_target_ship = closest_ship


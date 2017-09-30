extends Node


# When this node is attached as child to a DynamicBody2D (KineticBody2D+dynamic_body.gd)
# allows it to be controlled by player 1.
#
# It is intended to be installed in a Ship node.
#
# Only works one at a time.


var _head
var _physics
var _engines
var _team


func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	_engines = _head.get_node("Engines")
	_team = _head.get_node("Team")
	set_fixed_process(true)

func _fixed_process(delta):
	_choose_strategy()

func _choose_strategy():
	var target_ship 
	if (_head.target_ref and _head.target_ref.get_ref()):
		target_ship = _head.target_ref.get_ref()
		var distance = (_head.get_pos() - target_ship.get_pos()).length()
		if _head.are_shields_up():
			_pursue_target(target_ship)
		else:
			_flee_target(target_ship)

		if distance < Global.LASER_ATTACK_RANGE:
			_head.straight_shooting()
		else:
			_head.stop_shooting()
	else:
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
		_head.set_target(closest_ship)

func _pursue_target(target_ship):

	var distance_vec_normalized = (target_ship.get_pos() - _head.get_pos()).normalized()
	var distance_module = (target_ship.get_pos() - _head.get_pos()).length()
	var angle_towards_target = distance_vec_normalized.angle() - PI/2
	
	_engines.orienting_to(angle_towards_target, PI/24)
	var target_speed_along_axis = target_ship.get_node("BodyPhysics").get_speed().dot(distance_vec_normalized)
	
	var reference = (Global.ENGAGE_DISTANCE+Global.LASER_ATTACK_RANGE)/2
	var closeness_correction_to_speed = 1/PI*atan((distance_module-reference)/(reference/24))+0.48 #lorentzian function
	var desired_speed = Global.SPEED_MAX/2*closeness_correction_to_speed + target_speed_along_axis
	
	_engines.reduce_speed_along_direction(distance_vec_normalized.tangent(), 0.1)

	_engines.match_speed(_physics.get_speed(), desired_speed, distance_vec_normalized, 0.02)

func _flee_target(target_ship):
	var distance_vec_normalized = (target_ship.get_pos() - _head.get_pos()).normalized()
	var distance_module = (target_ship.get_pos() - _head.get_pos()).length()
	var angle_towards_target = distance_vec_normalized.angle() - PI/2
	
	_engines.orienting_to(angle_towards_target, PI/24)
	var target_speed_along_axis = target_ship.get_node("BodyPhysics").get_speed().dot(distance_vec_normalized)
	
	var reference = (Global.ENGAGE_DISTANCE+Global.LASER_ATTACK_RANGE)/2
	var closeness_correction_to_speed = 1/PI*atan((-distance_module+reference)/(reference/24))+0.48 #lorentzian function
	var desired_speed = Global.SPEED_MAX/2*closeness_correction_to_speed + target_speed_along_axis
	
	_engines.match_speed(_physics.get_speed(), desired_speed, -1*distance_vec_normalized, 0.02)

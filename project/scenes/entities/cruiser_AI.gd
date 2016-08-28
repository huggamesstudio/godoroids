extends Node


var _head
# Planet to be defended
var _locked_planet

# Informs if the ship has already been assigned to a planet
var _locked = false
var _in_orbit = false


func _ready():
	_head = get_parent()
	
	set_fixed_process(true)
	
	var sprite = _head.get_node("Sprite")
	var color = Color(1,1,0)
	sprite.set_modulate(color)

func _fixed_process(delta):
	if _locked:
		if _in_orbit:
			_orbital_adjustment()
		else:
			_go_to_planet()
	else:
		_search_planet()
	
	_look_for_targets()

# Searchs for the closest planet and locks it up
func _search_planet():
	var planets = get_tree().get_nodes_in_group("planets")
	if planets.empty():
		return
	var closest_distance
	var closest_planet
	for planet in planets:
		var distance = (_head.get_pos() - planet.get_pos()).length()
		if closest_distance and closest_planet:
			if distance < closest_distance:
				closest_distance = distance
				closest_planet = planet
		else:
			closest_distance = distance
			closest_planet = planet
	
	_locked_planet = closest_planet
	_locked = true

func _go_to_planet():
	var planet_radius = _locked_planet.get_node("Properties").get_radius()
	var distance = _head.get_pos() - _locked_planet.get_pos()
	if distance.length() > 1.7*planet_radius:
		var angle_towards_planet = distance.angle() + PI/2
		_head.orienting_to(angle_towards_planet, PI/24)
		_head.go_cruising_speed(1,0.01)
	elif(distance.length() < 1.7*planet_radius):
		var angle_fromwards_planet = distance.angle() - PI/2
		_head.orienting_to(angle_fromwards_planet, PI/24)
		if (_keep_distance(distance, 1.5*planet_radius, 10)):
			_match_speed(_head.get_speed(), _locked_planet.get_speed().length(), distance, 0.01)
		var speed = _head.get_speed()
		if speed.length() < 1:
			_head.set_retrorockets_vector(Vector2(distance.y, -distance.x))
			_head.retrorockets_on()
		elif speed.length() > 1:
			_head.set_retrorockets_vector(-Vector2(distance.y, -distance.x))
			_head.retrorockets_on()
		else:
			_head.retrorockets_off()
		
		
func _keep_distance(current_distance, desired_distance, tolerance):
	var success = false
	if (current_distance.length() < desired_distance - tolerance):
		_head.accelerating()
	elif (current_distance.length() > desired_distance + tolerance):
		_head.breaking()
	else:
		success = true
	return success

func _match_speed(current_speed, desired_speed, axis, tolerance):
	var axis_norm = axis.normalized()
	var speed_along_axis = current_speed.dot(axis_norm)
	if (speed_along_axis < desired_speed - tolerance):
		_head.accelerating()
	if (speed_along_axis > desired_speed + tolerance):
		_head.breaking()
	else:
		_head.engines_stop()

func _orbital_adjustment():
	var distance = _head.get_pos() - _locked_planet.get_pos()
	var angle_fromwards_planet = distance.angle() - PI/2 +2*PI
	_head.orienting_to(angle_fromwards_planet, PI/24)

func _look_for_targets():
	var ships = get_tree().get_nodes_in_group("ships")
	var reach = 3000
	var max_shooting_angle = PI/3
	var target
	for ship in ships:
		var distance = _head.get_pos() - ship.get_pos()
		var angle_forward = fposmod(distance.angle()+PI/2, 2*PI) - _head.get_rot()
		if ( distance.length() < reach and \
				(abs(angle_forward)<max_shooting_angle or abs(angle_forward-2*PI)<max_shooting_angle) ):
			target = ship
			break
			
	var systems = _head.get_node("Systems")
	if (target):
		systems.shooting_to(target.get_pos())
	else:
		systems.stop_shooting()

extends Node

var cruiser
# Planet to be defended
var locked_planet

# Informs if the ship has already been assigned to a planet
var locked = false
var in_orbit = false


func _ready():
	cruiser = self.get_parent()
	
	self.set_fixed_process(true)
	
	var sprite = cruiser.get_node("Sprite")
	var color = Color(1,1,0)
	sprite.set_modulate(color)

func _fixed_process(delta):
	if self.locked:
		if self.in_orbit:
			_orbital_adjustment()
		else:
			_go_to_planet()
	else:
		_search_planet()
	
	self._look_for_targets()

# Searchs for the closest planet and locks it up
func _search_planet():
	var planets = self.get_tree().get_nodes_in_group("planets")
	if planets.empty():
		return
	var closest_distance
	var closest_planet
	for planet in planets:
		var distance = (cruiser.get_pos() - planet.get_pos()).length()
		if closest_distance and closest_planet:
			if distance < closest_distance:
				closest_distance = distance
				closest_planet = planet
		else:
			closest_distance = distance
			closest_planet = planet
	
	self.locked_planet = closest_planet
	self.locked = true

func _go_to_planet():
	var planet_radius = locked_planet.get_node("Properties").get_radius()
	var distance = cruiser.get_pos() - locked_planet.get_pos()
	if distance.length() > 1.7*planet_radius:
		var angle_towards_planet = distance.angle() + PI/2
		cruiser.orienting_to(angle_towards_planet, PI/24)
		cruiser.go_cruising_speed(1,0.01)
	elif(distance.length() < 1.7*planet_radius):
		var angle_fromwards_planet = distance.angle() - PI/2
		cruiser.orienting_to(angle_fromwards_planet, PI/24)
		if (self._keep_distance(distance, 1.5*planet_radius, 10)):
			self._match_speed(cruiser.get_speed(), locked_planet.get_speed().length(), distance, 0.01)
		var speed = cruiser.get_speed()
		if speed.length() < 1:
			cruiser.set_retrorockets_vector(Vector2(distance.y, -distance.x))
			cruiser.retrorockets_on()
		elif speed.length() > 1:
			cruiser.set_retrorockets_vector(-Vector2(distance.y, -distance.x))
			cruiser.retrorockets_on()
		else:
			cruiser.retrorockets_off()
		
		
func _keep_distance(current_distance, desired_distance, tolerance):
	var success = false
	if (current_distance.length() < desired_distance - tolerance):
		cruiser.accelerating()
	elif (current_distance.length() > desired_distance + tolerance):
		cruiser.breaking()
	else:
		success = true
	return success

func _match_speed(current_speed, desired_speed, axis, tolerance):
	var axis_norm = axis.normalized()
	var speed_along_axis = current_speed.dot(axis_norm)
	if (speed_along_axis < desired_speed - tolerance):
		cruiser.accelerating()
	if (speed_along_axis > desired_speed + tolerance):
		cruiser.breaking()
	else:
		cruiser.engines_stop()

func _orbital_adjustment():
	var distance = cruiser.get_pos() - locked_planet.get_pos()
	var angle_fromwards_planet = distance.angle() - PI/2 +2*PI
	cruiser.orienting_to(angle_fromwards_planet, PI/24)

func _look_for_targets():
	var ships = self.get_tree().get_nodes_in_group("ships")
	var reach = 3000
	var max_shooting_angle = PI/3
	var target
	for ship in ships:
		var distance = cruiser.get_pos() - ship.get_pos()
		var angle_forward = fposmod(distance.angle()+PI/2, 2*PI) - cruiser.get_rot()
		if ( distance.length() < reach and \
				(abs(angle_forward)<max_shooting_angle or abs(angle_forward-2*PI)<max_shooting_angle) ):
			target = ship
			break
			
	var cruiser_systems = cruiser.get_node("CruiserSystems")
	if (target):
		cruiser_systems.shooting_to(target.get_pos())
	else:
		cruiser_systems.stop_shooting()
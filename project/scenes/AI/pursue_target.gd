extends "res://addons/com.brandonlamb.bt/root.gd"


func tick(actor, ctx):
	
	var engines
	if actor.has_node("Engines"):
		engines = actor.get_node("Engines")
	else:
		return FAILED
	
	var target_ship
	if (actor.target_ref and actor.target_ref.get_ref()):
		target_ship = actor.target_ref.get_ref()
	else:
		return FAILED
	var distance_vec_normalized = (target_ship.get_pos() - actor.get_pos()).normalized()
	var distance_module = (target_ship.get_pos() - actor.get_pos()).length()
	var angle_towards_target = distance_vec_normalized.angle() - PI/2
	
	engines.orienting_to(angle_towards_target, PI/24)
	var target_speed_along_axis = target_ship.get_node("BodyPhysics").get_speed().dot(distance_vec_normalized)
	
	var reference = (Global.ENGAGE_DISTANCE+Global.LASER_ATTACK_RANGE)/2
	var closeness_correction_to_speed = 1/PI*atan((distance_module-reference)/(reference/24))+0.48 #lorentzian function
	var desired_speed = Global.SPEED_MAX/2*closeness_correction_to_speed + target_speed_along_axis
	
	engines.reduce_speed_along_direction(distance_vec_normalized.tangent(), 0.1)

	
	engines.match_speed(actor.get_node("BodyPhysics").get_speed(), desired_speed, distance_vec_normalized, 0.02)
	
	return OK
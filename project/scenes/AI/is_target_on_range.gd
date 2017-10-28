extends "res://addons/com.brandonlamb.bt/root.gd"


func tick(actor, ctx):
	if (actor.target_ref and actor.target_ref.get_ref()):
		var target_ship = actor.target_ref.get_ref()
		var distance = (actor.get_pos() - target_ship.get_pos()).length()
	
		var is_on_range = distance < Global.LASER_ATTACK_RANGE
		if is_on_range:
			return OK

	actor.stop_shooting()
	return FAILED

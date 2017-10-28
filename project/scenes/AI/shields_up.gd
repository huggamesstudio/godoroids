extends "res://addons/com.brandonlamb.bt/root.gd"


func tick(actor, ctx):
	var is_ready_for_battle = actor.are_shields_up()
	if is_ready_for_battle:
		return OK
	else:
		return FAILED

extends "res://addons/com.brandonlamb.bt/root.gd"


func tick(actor, ctx):
	
	var ships = get_tree().get_nodes_in_group("ships")
	if ships.empty():
		return FAILED
	
	var team_idx = 0
	if actor.has_node("Team"):
		team_idx = actor.get_node("Team").get_team()
	
	var closest_distance
	var closest_ship
	for ship in ships:
		var target_team_idx = 0 # Neutral team
		if ship.get_node("Team") and ship.get_node("Team").has_method("get_team"):
				target_team_idx = ship.get_node("Team").get_team()
		if target_team_idx == team_idx:
			continue
		
		var distance = (actor.get_pos() - ship.get_pos()).length()
		if closest_distance and closest_ship:
			if distance < closest_distance:
				closest_distance = distance
				closest_ship = ship
		else:
			closest_distance = distance
			closest_ship = ship
	
	if closest_ship:
		actor.set_target(closest_ship)
		return OK
	else:
		return FAILED

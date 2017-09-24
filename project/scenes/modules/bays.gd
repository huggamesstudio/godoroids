extends Node


var _head


func _ready():
	_head = get_parent()
	
func eject_fighter():
	# Load and instance the player ship
	var fighter = load("res://scenes/entities/ship.tscn").instance()
	fighter.get_node("Team")._team = get_parent().get_node("Team")._team
	_head.get_parent().add_child(fighter)
	fighter.set_pos(_head.get_pos()+100*Vector2(-sin(_head.get_rot()), -cos(_head.get_rot())))
	fighter.set_rotd(_head.get_rotd()+90)
	fighter.get_node("BodyPhysics").set_speed(_head.get_node("BodyPhysics").get_speed())
	fighter.get_node("BodyPhysics").speed_impulse(2)
	
	# Load player 1 behavior (input) into the ship
	var player1_int = _head.get_node("Player1Input")
	if (player1_int != null):
		_head.remove_child(player1_int)
		fighter.add_child(player1_int)
	var hud = _head.get_parent().get_node("Hud")
	hud.set_reference_actor(fighter)
	

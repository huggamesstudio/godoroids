extends Node


var _head


func _ready():
	_head = get_parent()
	
func eject_fighter():
	# Load and instance the player ship
	var fighter = load("res://scenes/entities/ship.tscn").instance()
	_head.get_parent().add_child(fighter)
	fighter.set_pos(_head.get_pos()+Vector2(0, -100))
	fighter.get_node("BodyPhysics").speed_break(-10)
	fighter.set_rotd(_head.get_rotd()+90)
	
	# Load player 1 behavior (input) into the ship
	var player1_int = _head.get_node("Player1Input")
	if (player1_int != null):
		_head.remove_child(player1_int)
		fighter.add_child(player1_int)
	var camera = _head.get_node("Camera2D")
	if (camera != null):
		_head.remove_child(camera)
		fighter.add_child(camera)
	
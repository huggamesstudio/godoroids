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

func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	_systems = _head.get_node("Systems")
	_engines = _head.get_node("Engines")
	_bays = _head.get_node("Bays")
	set_process_input(true)
	
func _input(event):
	if _engines.is_in_automatic_mode():
		return
		
	if event.is_action_pressed("game_turnleft"):
		get_tree().set_input_as_handled()
		_engines.rotating_left()
	if event.is_action_released("game_turnleft"):
		get_tree().set_input_as_handled()
		_engines.rot_engines_stop()

	if event.is_action_pressed("game_turnright"):
		get_tree().set_input_as_handled()
		_engines.rotating_right()
	if event.is_action_released("game_turnright"):
		get_tree().set_input_as_handled()
		_engines.rot_engines_stop()

	if event.is_action_pressed("game_accel"):
		get_tree().set_input_as_handled()
		_engines.accelerating()
	if event.is_action_released("game_accel"):
		get_tree().set_input_as_handled()
		_engines.engines_stop()
	
	if event.is_action_pressed("game_break"):
		get_tree().set_input_as_handled()
		_engines.breaking()
	if event.is_action_released("game_break"):
		get_tree().set_input_as_handled()
		_engines.engines_stop()
	
	if event.is_action_pressed("game_shoot"):
		get_tree().set_input_as_handled()
		if _systems != null:
			_systems.shooting()
	if event.is_action_released("game_shoot"):
		get_tree().set_input_as_handled()
		if _systems != null:
			_systems.stop_shooting()
			
	if event.is_action_pressed("game_propulsion"):
		get_tree().set_input_as_handled()
		if _systems != null:
			_systems.start_charging_propulsion()
	if event.is_action_released("game_propulsion"):
		get_tree().set_input_as_handled()
		if _systems != null:
			_systems.propulsion()
	
	if event.is_action_pressed("game_fighter_eject"):
		get_tree().set_input_as_handled()
		if _bays != null:
			_bays.eject_fighter()



extends Node


# When this node is attached as child to a DynamicBody2D (KineticBody2D+dynamic_body.gd)
# allows it to be controlled by player 1.
#
# It is intended to be installed in a Ship node.
#
# Only works one at a time.


var _head
var _physics

func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	set_process_input(true)
	
func _input(event):
	ship_input(event)

func ship_input(event):
	if _physics.is_in_automatic_mode():
		return
	var ship_systems = _head.get_node("Systems")
		
	if event.is_action_pressed("game_turnleft"):
		get_tree().set_input_as_handled()
		_physics.rotating_left()
	if event.is_action_released("game_turnleft"):
		get_tree().set_input_as_handled()
		_physics.rot_engines_stop()

	if event.is_action_pressed("game_turnright"):
		get_tree().set_input_as_handled()
		_physics.rotating_right()
	if event.is_action_released("game_turnright"):
		get_tree().set_input_as_handled()
		_physics.rot_engines_stop()

	if event.is_action_pressed("game_accel"):
		get_tree().set_input_as_handled()
		_physics.accelerating()
	if event.is_action_released("game_accel"):
		get_tree().set_input_as_handled()
		_physics.engines_stop()
	
	if event.is_action_pressed("game_break"):
		get_tree().set_input_as_handled()
		_physics.breaking()
	if event.is_action_released("game_break"):
		get_tree().set_input_as_handled()
		_physics.engines_stop()
	
	if event.is_action_pressed("game_shoot"):
		get_tree().set_input_as_handled()
		if ship_systems != null:
			ship_systems.shooting()
	if event.is_action_released("game_shoot"):
		get_tree().set_input_as_handled()
		if ship_systems != null:
			ship_systems.stop_shooting()
			
	if event.is_action_pressed("game_propulsion"):
		get_tree().set_input_as_handled()
		if ship_systems != null:
			ship_systems.start_charging_propulsion()
	if event.is_action_released("game_propulsion"):
		get_tree().set_input_as_handled()
		if ship_systems != null:
			ship_systems.propulsion()



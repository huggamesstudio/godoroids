
extends Node

# When this node is attached as child to a DynamicBody2D (KineticBody2D+dynamic_body.gd)
# allows it to be controlled by player 1.
#
# It is intended to be installed in a Ship node.
#
# Only works one at a time.

var ship_body
var ship_systems

func _ready():
	ship_body = self.get_parent()
	ship_systems = ship_body.get_node("Systems")
	self.set_process_input(true)
	
func _input(event):
	self.ship_input(event)

func ship_input(event):
	if event.is_action_pressed("game_turnleft"):
		self.get_tree().set_input_as_handled()
		ship_body.turning_left = true
	if event.is_action_released("game_turnleft"):
		self.get_tree().set_input_as_handled()
		ship_body.turning_left = false

	if event.is_action_pressed("game_turnright"):
		self.get_tree().set_input_as_handled()
		ship_body.turning_right = true
	if event.is_action_released("game_turnright"):
		self.get_tree().set_input_as_handled()
		ship_body.turning_right = false

	if event.is_action_pressed("game_accel"):
		self.get_tree().set_input_as_handled()
		ship_body.accelerating = true
	if event.is_action_released("game_accel"):
		self.get_tree().set_input_as_handled()
		ship_body.accelerating = false
	
	if event.is_action_pressed("game_shoot"):
		self.get_tree().set_input_as_handled()
		if ship_systems != null:
			ship_systems.shooting(true)
	if event.is_action_released("game_shoot"):
		self.get_tree().set_input_as_handled()
		if ship_systems != null:
			ship_systems.shooting(false)




extends Node

func _ready():
	self.set_process_input(true)
	
func _input(event):
	self.ship_input(event)

func ship_input(event):
	var ship_body = self.get_parent()
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
		var ship_systems = ship_body.get_node("Systems")
		ship_systems.shooting(true)
	if event.is_action_released("game_shoot"):
		self.get_tree().set_input_as_handled()
		var ship_systems = ship_body.get_node("Systems")
		ship_systems.shooting(false)



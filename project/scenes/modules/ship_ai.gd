extends Node


# When this node is attached as child to a DynamicBody2D (KineticBody2D+dynamic_body.gd)
# allows it to be controlled by player 1.
#
# It is intended to be installed in a Ship node.
#
# Only works one at a time.


var _head
var _physics
var _engines
var _team


func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	_engines = _head.get_node("Engines")
	_team = _head.get_node("Team")
	
	set_fixed_process(true)
	
	_head.select_weapon('lasergun')

func _fixed_process(delta):
	var context = {}
	get_node("BehaviorTree").tick(_head, context)
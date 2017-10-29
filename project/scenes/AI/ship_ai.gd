extends Node


var _head


func _ready():
	_head = get_parent()
	_head.select_weapon('lasergun')
	set_fixed_process(true)


func _fixed_process(delta):
	var context = {}
	get_node("BehaviorTree").tick(_head, context)
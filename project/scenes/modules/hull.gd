extends Area2D


var _head


func _ready():
	_head = get_parent()
	connect("area_enter", self, "handle_collisions")


func handle_collisions(area):
	_head.hurt(100000)

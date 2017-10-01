extends Area2D


var _head


func _ready():
	_head = get_parent()
	connect("area_enter", self, "handle_collisions")


func handle_collisions(area):
	var collider_parent = area.get_parent()
	if collider_parent.is_in_group("planets") or collider_parent.is_in_group("ships"):
		_head.hurt(100000)

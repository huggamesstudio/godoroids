extends Node


var _head

const EARTH_RADIUS = 256
export var _radius = 1


func _ready():
	_head = get_parent()
	_head.add_to_group("planets")
	
	var sprite = _head.get_node("Sprite")
	sprite.set_scale(Vector2(_radius, _radius))
	var color = Color(0,0,1)
	sprite.set_modulate(color)
	
	_head.get_node("CollisionCircle").get_shape().set_radius(_radius*EARTH_RADIUS)


func get_radius():
	return _radius*EARTH_RADIUS

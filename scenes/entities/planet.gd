
extends Node

var planet

const EARTH_RADIUS = 256
export var radius = 1

func _ready():
	planet = self.get_parent()
	planet.add_to_group("planets")
	
	var sprite = planet.get_node("Sprite")
	sprite.set_scale(Vector2(radius, radius))
	var color = Color(0,0,1)
	sprite.set_modulate(color)
	
	planet.get_node("CollisionCircle").get_shape().set_radius(radius*EARTH_RADIUS)



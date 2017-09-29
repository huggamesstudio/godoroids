extends Node

var _head
var _physics

export var quality_tier = 1 #From 1 to 5, being 5 the best weapong

func _ready():
	_head = get_parent().get_parent()
	_physics = _head.get_node("BodyPhysics")

func shoot(shooting_angle):
	var missile = load("res://scenes/entities/missile.tscn").instance()
	missile.set_scale(Vector2(0.6, 0.6))
	missile.set_rot(shooting_angle)
	missile.set_pos(_head.get_pos()+Vector2(cos(missile.get_rot()),-sin(missile.get_rot()))*100)
	_head.get_parent().add_child(missile)
	missile.get_node("BodyPhysics").change_speed(_physics.get_speed())

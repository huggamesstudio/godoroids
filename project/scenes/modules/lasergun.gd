extends Node

var _head
var _physics

func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")

func shoot(shooting_angle):
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_scale(Vector2(0.4, 0.4))
	laser.set_rot(shooting_angle)
	laser.set_pos(_head.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	_head.get_parent().add_child(laser)
	laser.get_node("BodyPhysics").change_speed(_physics.get_speed())

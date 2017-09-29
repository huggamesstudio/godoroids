extends Node

var _head
var _physics

export var quality_tier = 1 #From 1 to 5, being 5 the best weapong

func _ready():
	_head = get_parent().get_parent()
	_physics = _head.get_node("BodyPhysics")

func shoot(shooting_angle):
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_scale(Vector2(0.4, 0.4))
	var dispersion_angle = PI/9/quality_tier
	var gun_inaccuracy_deviation = (randf()-0.5)*dispersion_angle
	laser.set_rot(shooting_angle+gun_inaccuracy_deviation)
	laser.set_pos(_head.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	_head.get_parent().add_child(laser)
	laser.get_node("BodyPhysics").change_speed(_physics.get_speed())

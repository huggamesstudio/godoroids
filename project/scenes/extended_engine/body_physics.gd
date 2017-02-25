extends Node


# This script extends a KinematicBody2D to implement _speed and acceleration.
# It converts it into a "DynamicBody2D".

const SPEED_MAX = 30.0
const ROT_SPEED_MAX = 20.0
const ROT_FRICTION = 7.5

export var _speed = Vector2(0, 0)
export var _rot_speed = 0

var _head

func _ready():
	set_fixed_process(true)
	_head = get_parent()

func _fixed_process(delta):
	
	if abs(_rot_speed) <= (ROT_FRICTION * delta):
		_rot_speed = 0
	else:
		change_rot_speed(-1*sign(_rot_speed)*ROT_FRICTION*delta)
	_head.set_rot(_head.get_rot()+_rot_speed * delta)
	
	if _head.has_method("move"):
		_head.move(_speed)
	else:
		_head.set_pos(_head.get_pos()+_speed*delta*100)

func get_speed():
	return _speed

func change_speed(speed_delta):
	_speed += speed_delta
	if _speed.length() > SPEED_MAX:
		_speed = _speed.normalized()*SPEED_MAX

func speed_impulse(speed_delta_impulse):
	var rot = _head.get_rot()
	var speed_delta = speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	change_speed(speed_delta)

func speed_break(speed_delta_impulse):
	var rot = _head.get_rot()
	var speed_delta = speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	change_speed(-speed_delta)

func get_rot_speed():
	return _rot_speed

func change_rot_speed(rot_speed_delta):
	_rot_speed += rot_speed_delta
	if abs(_rot_speed) > ROT_SPEED_MAX:
		_rot_speed = sign(_rot_speed)*ROT_SPEED_MAX

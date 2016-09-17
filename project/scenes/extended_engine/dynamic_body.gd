extends Node


# This script extends a KinematicBody2D to implement _speed and acceleration.
# It converts it into a "DynamicBody2D".


const LINEAR_ACCEL = 1.5
const RETROROCKET_ACCEL = 1.5
const SPD_MAX = 30.0

const ROT_ACCEL = 22.5
const ROT_SPEED_MAX = 20.0
const ROT_FRICTION = 7.5

export var _speed = Vector2(0, 0)
export var _rotation_speed = 0

var _accelerating = false
var _retrorockets_adjusting = false
var _retrorockets_vector = Vector2(1,0)
var _breaking = false
var _rotating_left = false
var _rotating_right = false

var _automatic_mode

var _head

func _ready():
	_head = get_parent()
	set_fixed_process(true)

func _fixed_process(delta):
	movement(delta)

func get_speed():
	return _speed

func set_retrorockets_vector(new_retrorocket_vector):
	_retrorockets_vector = new_retrorocket_vector.normalized()

func accelerating():
	_accelerating = true
	_breaking = false

func breaking():
	_accelerating = false
	_breaking = true

func engines_stop():
	_accelerating = false
	_breaking = false

func retrorockets_on():
	_retrorockets_adjusting = true

func retrorockets_off():
	_retrorockets_adjusting = false

func rotating_left():
	_rotating_left=true
	_rotating_right=false

func rotating_right():
	_rotating_left=false
	_rotating_right=true

func rot_engines_stop():
	_rotating_left=false
	_rotating_right=false

func change_speed(_speed_delta):
	_speed += _speed_delta
	if _speed.length() > SPD_MAX:
		_speed = _speed.normalized()*SPD_MAX

func _speed_impulse(_speed_delta_impulse):
	var rot = _head.get_rot()
	var _speed_delta = _speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	change_speed(_speed_delta)

func _speed_break(_speed_delta_impulse):
	var rot = _head.get_rot()
	var _speed_delta = _speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	change_speed(-_speed_delta)

func go_still(tolerance):
	if _speed.length()<tolerance:
		retrorockets_off()
		return true
	var stoping_vector = -_speed
	set__retrorockets_vector(stoping_vector)
	retrorockets_on()
	return false
	
func go_cruising_speed(cruising_speed, tolerance):
	var success = true
	var drifting_angle = _head.get_rot() - (_speed.angle()+PI/2)
	var drifting_speed = _speed.length()*sin(drifting_angle)
	var facing_forward = -cos(drifting_angle) > 0
	if (abs(drifting_speed) > tolerance):
		set_retrorockets_vector(sign(drifting_speed)*Vector2(sin(_head.get_rot()), cos(_head.get_rot())))
		retrorockets_on()
		success = false
	else:
		retrorockets_off()
		success = true
	
	var delta_speed = _speed.length()-cruising_speed
	if ( abs(delta_speed) > tolerance ):
		if ( !facing_forward or delta_speed < 0 ):
			accelerating()
		elif( delta_speed > 0 ):
			breaking()
		success = false
	else:
		engines_stop()
	
	return success

func stop_rotation():
	if _rotation_speed > ROT_SPEED_MAX/10:
		rotating_right()
	elif _rotation_speed < -ROT_SPEED_MAX/10:
		rotating_left()
	else:
		rot_engines_stop()
		if (_rotation_speed == 0):
			return true
	
	return false

func orienting_to(free_range_angle, tolerance):
	var target_angle = fposmod(free_range_angle, 2*PI)
	var self_rot = fposmod(_head.get_rot(),2*PI)
	if (abs(target_angle-self_rot) < tolerance):
		stop_rotation()
		return true
	elif( self_rot-target_angle > 0 and abs(self_rot-target_angle) < PI ) or \
		( self_rot-target_angle < 0 and abs(self_rot-target_angle) > PI ):
		rotating_right()
	elif( self_rot-target_angle <= 0 and abs(self_rot-target_angle) <= PI ) or \
		( self_rot-target_angle >= 0 and abs(self_rot-target_angle) >= PI ):
		rotating_left()
	return false
	
func movement(delta):
	if _rotating_left:
		_rotation_speed += ROT_ACCEL * delta
	if _rotating_right:
		_rotation_speed -= ROT_ACCEL * delta
	if _accelerating:
		_speed_impulse(LINEAR_ACCEL * delta)
	if _breaking:
		_speed_break(RETROROCKET_ACCEL * delta)
	if _retrorockets_adjusting:
		change_speed(RETROROCKET_ACCEL * delta * _retrorockets_vector)
		
	if abs(_rotation_speed) > ROT_SPEED_MAX:
		if _rotation_speed > 0:
			_rotation_speed = ROT_SPEED_MAX
		else:
			_rotation_speed = -ROT_SPEED_MAX

	if abs(_rotation_speed) <= (ROT_FRICTION * delta):
		_rotation_speed = 0
	if abs(_rotation_speed) > (ROT_FRICTION * delta):
		if _rotation_speed > 0:
			_rotation_speed -= ROT_FRICTION * delta
		else:
			_rotation_speed += ROT_FRICTION * delta

	_head.set_rot(_head.get_rot()+_rotation_speed * delta)
	if _head.has_method("move"):
		_head.move(_speed)
	else:
		_head.set_pos(_head.get_pos()+_speed*delta*100)

func is_in_automatic_mode():
	return _automatic_mode

func automatic_mode(enable):
	_automatic_mode = enable

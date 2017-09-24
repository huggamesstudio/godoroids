
extends Node


const LINEAR_ACCEL = 1.5
const THRUSTER_ACCEL = 1.5
const ROT_ACCEL = 22.5

var _accelerating = false
var _thrusters_adjusting = false
var _thrusters_vector = Vector2(1,0)
var _breaking = false

var _rotating_left = false
var _rotating_right = false

var _automatic_mode

var _head
var _physics

func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	
	set_fixed_process(true)

func _fixed_process(delta):
	movement(delta)

func set_thrusters_vector(new_thruster_vector):
	_thrusters_vector = new_thruster_vector.normalized()

func accelerating():
	_accelerating = true
	_breaking = false

func breaking():
	_accelerating = false
	_breaking = true

func engines_stop():
	_accelerating = false
	_breaking = false

func rotating_left():
	_rotating_left=true
	_rotating_right=false

func rotating_right():
	_rotating_left=false
	_rotating_right=true

func rot_engines_stop():
	_rotating_left=false
	_rotating_right=false

func thrusters_on():
	_thrusters_adjusting = true

func thrusters_off():
	_thrusters_adjusting = false

func movement(delta):
	if _rotating_left:
		_physics.change_rot_speed(ROT_ACCEL * delta)
	if _rotating_right:
		_physics.change_rot_speed(-ROT_ACCEL * delta)
	if _accelerating:
		_physics.speed_impulse(LINEAR_ACCEL * delta)
	if _breaking:
		_physics.speed_break(THRUSTER_ACCEL * delta)
	if _thrusters_adjusting:
		_physics.change_speed(THRUSTER_ACCEL * delta * _thrusters_vector)

func go_still(tolerance):
	var speed = _physics.get_speed()
	if speed.length()<tolerance:
		thrusters_off()
		return true
	var stoping_vector = -speed
	set__thrusters_vector(stoping_vector)
	thrusters_on()
	return false
	
func go_cruising_speed(cruising_speed, tolerance):
	var speed = _physics.get_speed()
	var success = true
	var drifting_angle = _head.get_rot() - (speed.angle()+PI/2)
	var drifting_speed = speed.length()*sin(drifting_angle)
	var facing_forward = -cos(drifting_angle) > 0
	if (abs(drifting_speed) > tolerance):
		set_thrusters_vector(sign(drifting_speed)*Vector2(sin(_head.get_rot()), cos(_head.get_rot())))
		thrusters_on()
		success = false
	else:
		thrusters_off()
		success = true
	
	var delta_speed = speed.length()-cruising_speed
	if ( abs(delta_speed) > tolerance ):
		if ( !facing_forward or delta_speed < 0 ):
			accelerating()
		elif( delta_speed > 0 ):
			breaking()
		success = false
	else:
		engines_stop()
	
	return success

func reduce_speed_along_direction(direction, tolerance):
	var speed = _physics.get_speed()
	var drifting_speed = speed.dot(direction.normalized())
	if (abs(drifting_speed) > tolerance):
		set_thrusters_vector(-sign(drifting_speed)*direction)
		thrusters_on()
	else:
		thrusters_off()

func match_speed(current_speed_vec, desired_speed, axis, tolerance):
	var axis_norm = axis.normalized()
	var speed_along_axis = current_speed_vec.dot(axis_norm)
	var pointing_vector = Vector2(cos(_head.get_rot()),-sin(_head.get_rot()))
	var pointing_towards_axis_direction = (axis.dot(pointing_vector) > 0)
	if (speed_along_axis < desired_speed - tolerance):
		if pointing_towards_axis_direction:
			accelerating()
		else:
			breaking()
	elif (speed_along_axis > desired_speed + tolerance):
		if pointing_towards_axis_direction:
			breaking()
		else:
			accelerating()
	else:
		engines_stop()

func stop_rotation(tolerance):
	var rot_speed = _physics.get_rot_speed()
	if  rot_speed > tolerance:
		rotating_right()
	elif rot_speed < -tolerance:
		rotating_left()
	else:
		rot_engines_stop()
		if (rot_speed == 0):
			return true
	
	return false

func orienting_to(free_range_angle, tolerance):
	var target_angle = fposmod(free_range_angle, 2*PI)
	var self_rot = fposmod(_head.get_rot(),2*PI)
	if (abs(target_angle-self_rot) < tolerance):
		stop_rotation(2)
		return true
	elif( self_rot-target_angle > 0 and abs(self_rot-target_angle) < PI ) or \
		( self_rot-target_angle < 0 and abs(self_rot-target_angle) > PI ):
		rotating_right()
	elif( self_rot-target_angle <= 0 and abs(self_rot-target_angle) <= PI ) or \
		( self_rot-target_angle >= 0 and abs(self_rot-target_angle) >= PI ):
		rotating_left()
	return false
	
func is_in_automatic_mode():
	return _automatic_mode

func automatic_mode(enable):
	_automatic_mode = enable

extends KinematicBody2D

# This script extends a KinematicBody2D to implement speed and acceleration.
# It converts it into a "DynamicBody2D".

const LINEAR_ACCEL = 1.5
const RETROROCKET_ACCEL = 1.5
const SPD_MAX = 30.0

const ROT_ACCEL = 22.5
const ROT_SPEED_MAX = 20.0
const ROT_FRICTION = 7.5

export var speed = Vector2(0, 0)
export var rotation_speed = 0

var accelerating = false
var retrorockets_adjusting = false
var retrorockets_vector = Vector2(1,0)
var breaking = false
var rotating_left = false
var rotating_right = false

var automatic_mode

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	movement(delta)

func get_speed():
	return speed

func set_retrorockets_vector(new_retrorocket_vector):
	retrorockets_vector = new_retrorocket_vector.normalized()

func accelerating():
	accelerating = true
	breaking = false

func breaking():
	accelerating = false
	breaking = true

func engines_stop():
	accelerating = false
	breaking = false

func retrorockets_on():
	retrorockets_adjusting = true

func retrorockets_off():
	retrorockets_adjusting = false

func rotating_left():
	rotating_left=true
	rotating_right=false

func rotating_right():
	rotating_left=false
	rotating_right=true

func rot_engines_stop():
	rotating_left=false
	rotating_right=false

func change_speed(speed_delta):
	speed += speed_delta
	if speed.length() > SPD_MAX:
		speed = speed.normalized()*SPD_MAX

func speed_impulse(speed_delta_impulse):
	var rot = get_rot()
	var speed_delta = speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	change_speed(speed_delta)

func speed_break(speed_delta_impulse):
	var rot = get_rot()
	var speed_delta = speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	change_speed(-speed_delta)

func go_still(tolerance):
	if speed.length()<tolerance:
		retrorockets_off()
		return true
	var stoping_vector = -speed
	set_retrorockets_vector(stoping_vector)
	retrorockets_on()
	return false
	
func go_cruising_speed(cruising_speed, tolerance):
	var success = true
	var drifting_angle = get_rot() - (speed.angle()+PI/2)
	var drifting_speed = speed.length()*sin(drifting_angle)
	var facing_forward = -cos(drifting_angle) > 0
	if (abs(drifting_speed) > tolerance):
		set_retrorockets_vector(sign(drifting_speed)*Vector2(sin(get_rot()), cos(get_rot())))
		retrorockets_on()
		success = false
	else:
		retrorockets_off()
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

func stop_rotation():
	if rotation_speed > ROT_SPEED_MAX/10:
		rotating_right()
	elif rotation_speed < -ROT_SPEED_MAX/10:
		rotating_left()
	else:
		rot_engines_stop()
		if (rotation_speed == 0):
			return true
	
	return false

func orienting_to(free_range_angle, tolerance):
	var target_angle = fposmod(free_range_angle, 2*PI)
	var self_rot = fposmod(get_rot(),2*PI)
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
	if rotating_left:
		rotation_speed += ROT_ACCEL * delta
	if rotating_right:
		rotation_speed -= ROT_ACCEL * delta
	if accelerating:
		speed_impulse(LINEAR_ACCEL * delta)
	if breaking:
		speed_break(RETROROCKET_ACCEL * delta)
	if retrorockets_adjusting:
		change_speed(RETROROCKET_ACCEL * delta * retrorockets_vector)
		
	if abs(rotation_speed) > ROT_SPEED_MAX:
		if rotation_speed > 0:
			rotation_speed = ROT_SPEED_MAX
		else:
			rotation_speed = -ROT_SPEED_MAX

	if abs(rotation_speed) <= (ROT_FRICTION * delta):
		rotation_speed = 0
	if abs(rotation_speed) > (ROT_FRICTION * delta):
		if rotation_speed > 0:
			rotation_speed -= ROT_FRICTION * delta
		else:
			rotation_speed += ROT_FRICTION * delta

	set_rot(get_rot()+rotation_speed * delta)
	
	if is_colliding():
		speed = Vector2(0,0)
	
	move(speed)

func is_in_automatic_mode():
	return automatic_mode

func automatic_mode(enable):
	automatic_mode = enable

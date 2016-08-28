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
	self.set_fixed_process(true)

func _fixed_process(delta):
	self.movement(delta)

func get_speed():
	return self.speed

func set_retrorockets_vector(new_retrorocket_vector):
	self.retrorockets_vector = new_retrorocket_vector.normalized()

func accelerating():
	self.accelerating = true
	self.breaking = false

func breaking():
	self.accelerating = false
	self.breaking = true

func engines_stop():
	self.accelerating = false
	self.breaking = false

func retrorockets_on():
	self.retrorockets_adjusting = true

func retrorockets_off():
	self.retrorockets_adjusting = false

func rotating_left():
	self.rotating_left=true
	self.rotating_right=false

func rotating_right():
	self.rotating_left=false
	self.rotating_right=true

func rot_engines_stop():
	self.rotating_left=false
	self.rotating_right=false

func change_speed(speed_delta):
	self.speed += speed_delta
	if self.speed.length() > SPD_MAX:
		self.speed = self.speed.normalized()*SPD_MAX

func speed_impulse(speed_delta_impulse):
	var rot = self.get_rot()
	var speed_delta = speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	self.change_speed(speed_delta)

func speed_break(speed_delta_impulse):
	var rot = self.get_rot()
	var speed_delta = speed_delta_impulse*Vector2(cos(rot), -sin(rot))
	self.change_speed(-speed_delta)

func go_still(tolerance):
	if self.speed.length()<tolerance:
		self.retrorockets_off()
		return true
	var stoping_vector = -self.speed
	self.set_retrorockets_vector(stoping_vector)
	self.retrorockets_on()
	return false
	
func go_cruising_speed(cruising_speed, tolerance):
	var success = true
	var drifting_angle = self.get_rot() - (self.speed.angle()+PI/2)
	var drifting_speed = self.speed.length()*sin(drifting_angle)
	var facing_forward = -cos(drifting_angle) > 0
	if (abs(drifting_speed) > tolerance):
		self.set_retrorockets_vector(sign(drifting_speed)*Vector2(sin(self.get_rot()), cos(self.get_rot())))
		self.retrorockets_on()
		success = false
	else:
		self.retrorockets_off()
		success = true
	
	var delta_speed = self.speed.length()-cruising_speed
	if ( abs(delta_speed) > tolerance ):
		if ( !facing_forward or delta_speed < 0 ):
			self.accelerating()
		elif( delta_speed > 0 ):
			self.breaking()
		success = false
	else:
		self.engines_stop()
	
	return success

func stop_rotation():
	if self.rotation_speed > self.ROT_SPEED_MAX/10:
		self.rotating_right()
	elif self.rotation_speed < -self.ROT_SPEED_MAX/10:
		self.rotating_left()
	else:
		self.rot_engines_stop()
		if (self.rotation_speed == 0):
			return true
	
	return false

func orienting_to(free_range_angle, tolerance):
	var target_angle = fposmod(free_range_angle, 2*PI)
	var self_rot = fposmod(self.get_rot(),2*PI)
	if (abs(target_angle-self_rot) < tolerance):
		self.stop_rotation()
		return true
	elif( self_rot-target_angle > 0 and abs(self_rot-target_angle) < PI ) or \
		( self_rot-target_angle < 0 and abs(self_rot-target_angle) > PI ):
		self.rotating_right()
	elif( self_rot-target_angle <= 0 and abs(self_rot-target_angle) <= PI ) or \
		( self_rot-target_angle >= 0 and abs(self_rot-target_angle) >= PI ):
		self.rotating_left()
	return false
	
func movement(delta):
	if self.rotating_left:
		self.rotation_speed += ROT_ACCEL * delta
	if self.rotating_right:
		self.rotation_speed -= ROT_ACCEL * delta
	if self.accelerating:
		self.speed_impulse(LINEAR_ACCEL * delta)
	if self.breaking:
		self.speed_break(RETROROCKET_ACCEL * delta)
	if self.retrorockets_adjusting:
		self.change_speed(RETROROCKET_ACCEL * delta * self.retrorockets_vector)
		
	if abs(self.rotation_speed) > ROT_SPEED_MAX:
		if self.rotation_speed > 0:
			self.rotation_speed = ROT_SPEED_MAX
		else:
			self.rotation_speed = -ROT_SPEED_MAX

	if abs(self.rotation_speed) <= (ROT_FRICTION * delta):
		self.rotation_speed = 0
	if abs(self.rotation_speed) > (ROT_FRICTION * delta):
		if self.rotation_speed > 0:
			self.rotation_speed -= ROT_FRICTION * delta
		else:
			self.rotation_speed += ROT_FRICTION * delta

	self.set_rot(self.get_rot()+self.rotation_speed * delta)
	
	if self.is_colliding():
		self.speed = Vector2(0,0)
	
	self.move(self.speed)

func is_in_automatic_mode():
	return self.automatic_mode

func automatic_mode(enable):
	self.automatic_mode = enable
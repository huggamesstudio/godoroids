extends KinematicBody2D

# This script extends a KinematicBody2D to implement speed and acceleration.
# It converts it into a "DynamicBody2D".

export var LINEAR_ACCEL = 1.5
export var SPD_MAX = 30.0

export var ROT_ACCEL = 22.5
export var ROT_SPEED_MAX = 150.0
export var ROT_FRICTION = 7.5

export var speed = Vector2(0, 0)
export var rotation_speed = 0
export var reload_countdown = 0

var turning_left = false
var turning_right = false
var accelerating = false

func _ready():
	self.set_fixed_process(true)

func _fixed_process(delta):
	self.movement(delta)

func change_speed(speed_delta):
	self.speed += speed_delta
	if self.speed.length() > SPD_MAX:
		self.speed = self.speed.normalized()*SPD_MAX
	
func movement(delta):
	if self.turning_left:
		self.rotation_speed += ROT_ACCEL * delta
	if self.turning_right:
		self.rotation_speed -= ROT_ACCEL * delta
	if self.accelerating:
		self.change_speed(Vector2(cos(self.get_rot()), -sin(self.get_rot()))*LINEAR_ACCEL * delta)
		
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

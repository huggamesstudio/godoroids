extends Node2D

const SPD_SCALE_FACTOR = 1
const ROT_SCALE_FACTOR = 5

const SPD_ACCEL = 0.05 * SPD_SCALE_FACTOR
const SPD_MAX = 15 * SPD_SCALE_FACTOR
var speed = Vector2(0, 0)

const ROT_ACCEL = 0.2 * ROT_SCALE_FACTOR
const ROT_MAX = 1 * ROT_SCALE_FACTOR
const ROT_FRICTION = 0.05 * ROT_SCALE_FACTOR
var rotation_speed = 0

var RELOAD_TIME = 0.1
var reload_countdown = 0

var turning_left = false
var turning_right = false
var accelerating = false
var shooting = false


func _ready():
	self.set_process(true)
	self.set_process_input(true)

func _process(delta):

	if self.turning_left:
		self.rotation_speed += ROT_ACCEL
	if self.turning_right:
		self.rotation_speed -= ROT_ACCEL
	if self.accelerating:
		self.speed.x += cos(self.get_rot())*SPD_ACCEL
		self.speed.y += -sin(self.get_rot())*SPD_ACCEL

	if self.speed.length()>SPD_MAX:
		self.speed = self.speed.normalized()*SPD_MAX
		
	if abs(self.rotation_speed)>ROT_MAX:
		if self.rotation_speed > 0:
			self.rotation_speed = ROT_MAX
		else:
			self.rotation_speed = -ROT_MAX

	if abs(self.rotation_speed)<=ROT_FRICTION:
		self.rotation_speed = 0
	if abs(self.rotation_speed)>ROT_FRICTION:
		if self.rotation_speed > 0:
			self.rotation_speed -= ROT_FRICTION
		else:
			self.rotation_speed += ROT_FRICTION

	var current_rotation = self.get_rotd()
	current_rotation += self.rotation_speed
	self.set_rotd(current_rotation)
	
	if self.shooting and self.reload_countdown <= 0:
		self.reload_countdown = self.RELOAD_TIME
		var laser = load("res://scenes/entities/laser.tscn").instance()
		laser.set_rot(self.get_rot())
		laser.set_pos(self.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*50)
		self.get_parent().add_child(laser)
	if reload_countdown > 0:
		self.reload_countdown -= delta
	
	self.move(self.speed)


func _input(event):
	if event.is_action_pressed("game_turnleft"):
		self.get_tree().set_input_as_handled()
		self.turning_left = true
	if event.is_action_released("game_turnleft"):
		self.get_tree().set_input_as_handled()
		self.turning_left = false

	if event.is_action_pressed("game_turnright"):
		self.get_tree().set_input_as_handled()
		self.turning_right = true
	if event.is_action_released("game_turnright"):
		self.get_tree().set_input_as_handled()
		self.turning_right = false

	if event.is_action_pressed("game_accel"):
		self.get_tree().set_input_as_handled()
		self.accelerating = true
	if event.is_action_released("game_accel"):
		self.get_tree().set_input_as_handled()
		self.accelerating = false
	
	if event.is_action_pressed("game_shoot"):
		self.get_tree().set_input_as_handled()
		self.shooting = true
	if event.is_action_released("game_shoot"):
		self.get_tree().set_input_as_handled()
		self.shooting = false
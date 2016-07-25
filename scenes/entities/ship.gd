extends Node2D


const SPD_SCALE_FACTOR = 1
const ROT_SCALE_FACTOR = 5

const SPD_ACCEL = 0.5 * SPD_SCALE_FACTOR
const SPD_MAX = 15 * SPD_SCALE_FACTOR
var speed = 0

const ROT_ACCEL = 0.2 * ROT_SCALE_FACTOR
const ROT_MAX = 1 * ROT_SCALE_FACTOR
const ROT_FRICTION = 0.05 * ROT_SCALE_FACTOR
var rotation_speed = 0

var turning_left = false
var turning_right = false
var accelerating = false


func _ready():
	self.set_process(true)
	self.set_process_input(true)


func _process(delta):

	if self.turning_left:
		self.rotation_speed += ROT_ACCEL
	if self.turning_right:
		self.rotation_speed -= ROT_ACCEL
	if self.accelerating:
		self.speed += SPD_ACCEL

	if abs(self.speed)>SPD_MAX:
		if self.speed > 0:
			self.speed = SPD_MAX
		else:
			self.speed = -SPD_MAX

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

	var current_position = self.get_pos()
	if self.speed:
		current_position.x += cos(deg2rad(current_rotation)) * self.speed
		current_position.y += sin(deg2rad(-current_rotation)) * self.speed
		self.set_pos(current_position)


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
extends Node2D

const LIFE_MAX = 100
export var life = 100

const SPD_SCALE_FACTOR = 1*30
const ROT_SCALE_FACTOR = 5*30

const LINEAR_ACCEL = 0.05 * SPD_SCALE_FACTOR
const SPD_MAX = 0.1 * SPD_SCALE_FACTOR
export var speed = Vector2(0, 0)

const ROT_ACCEL = 0.15 * ROT_SCALE_FACTOR
const ROT_SPEED_MAX = 1 * ROT_SCALE_FACTOR
const ROT_FRICTION = 0.05 * ROT_SCALE_FACTOR
export var rotation_speed = 0

const RELOAD_TIME = 0.2
export var reload_countdown = 0

var turning_left = false
var turning_right = false
var accelerating = false
var shooting = false

func _ready():
	self.set_fixed_process(true)
	self.set_process_input(true)
	add_to_group("ships")
	self.life = self.LIFE_MAX
	self.add_to_group("GameComponents")

func _fixed_process(delta):
	self.movement(delta)

func _input(event):
	self.ship_input(event)
	
func hurt(damage):
	self.life -= damage
	if self.life <= 0:
		self.die();
		
func die():
	self.queue_free()
	
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

	var current_rotation = self.get_rot()
	self.set_rot(current_rotation+self.rotation_speed * delta)
	
	if self.shooting and self.reload_countdown <= 0:
		self.reload_countdown = self.RELOAD_TIME
		var laser = load("res://scenes/entities/laser.tscn").instance()
		laser.set_rot(self.get_rot())
		laser.set_pos(self.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
		self.get_parent().add_child(laser)
		laser.change_speed(self.speed)
	if reload_countdown > 0:
		self.reload_countdown -= delta
	
	if self.is_colliding():
		self.speed = Vector2(0,0)
	
	self.move(self.speed)
	
func ship_input(event):
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

extends Node

const MAX_LIFE = 100
const RELOAD_TIME = 0.2

var cruiser

export var life = 100


var shooting = false
var shooting_angle = 0
var reload_countdown = 0

func _ready():
	cruiser = self.get_parent()
	
	self.set_fixed_process(true)


func _fixed_process(delta):

	if self.shooting and self.reload_countdown <= 0:
		self.shoot()
	if self.reload_countdown > 0:
		self.reload_countdown -= delta

func shooting():
	self.shooting = true
	self.shooting_angle = cruiser.get_rot()

func shooting_to(target_pos):
	self.shooting = true
	var distance = cruiser.get_pos() - target_pos
	self.shooting_angle = distance.angle() + PI/2

func stop_shooting():
	self.shooting = false

func shoot():
	self.reload_countdown = self.RELOAD_TIME
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_rot(self.shooting_angle)
	laser.set_pos(cruiser.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	cruiser.get_parent().add_child(laser)
	laser.change_speed(cruiser.speed)

func hurt(damage):
	self.life -= damage
	if self.life <= 0:
		self.die();

func die():
	self.queue_free()
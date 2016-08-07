
extends Node

const LIFE_MAX = 100
export var life = 100

const RELOAD_TIME = 0.2
export var reload_countdown = 0

var shooting = false

func _ready():
	self.set_process(true)
	self.get_parent().add_to_group("ships")
	self.life = self.LIFE_MAX

func _process(delta):
	# Shooting
	if self.shooting and self.reload_countdown <= 0:
		self.shoot()
	if self.reload_countdown > 0:
		self.reload_countdown -= delta

func shooting(enable):
	self.shooting = enable

func hurt(damage):
	self.life -= damage
	if self.life <= 0:
		self.die();

func die():
	self.queue_free()

func shoot():
	var ship_body = self.get_parent()
	self.reload_countdown = self.RELOAD_TIME
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_rot(ship_body.get_rot())
	laser.set_pos(ship_body.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	ship_body.get_parent().add_child(laser)
	laser.change_speed(ship_body.speed)

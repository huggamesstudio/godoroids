
extends Node

# This node is intended to take care of everything related to the ships except
# movement: shooting, shields/life, ..

const MAX_LIFE = 100
const MAX_PROPULSION_CHARGE = 1.0
const MAX_PROPULSION_SPD_CHANGE = 20
const RELOAD_TIME = 0.2

var ship

export var life = 100
var reload_countdown = 0
var propulsion_charge = 0

var shooting = false
var charging_propulsion = false

func _ready():
	self.set_process(true)
	ship = self.get_parent()
	ship.add_to_group("ships")
	self.life = self.MAX_LIFE

func _process(delta):
	# Shooting
	if self.shooting and self.reload_countdown <= 0:
		self.shoot()
	if self.reload_countdown > 0:
		self.reload_countdown -= delta
	
	if self.charging_propulsion and self.propulsion_charge < MAX_PROPULSION_CHARGE :
		propulsion_charge += delta*0.2

func shooting(enable):
	self.shooting = enable

func hurt(damage):
	self.life -= damage
	if self.life <= 0:
		self.die();

func die():
	self.queue_free()

func start_charging_propulsion():
	charging_propulsion = true

func propulsion():
	charging_propulsion = false
	var speed_impulse = pow(propulsion_charge,2)*MAX_PROPULSION_SPD_CHANGE
	ship.speed_impulse(speed_impulse)
	propulsion_charge = 0.0

func shoot():
	self.reload_countdown = self.RELOAD_TIME
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_rot(ship.get_rot())
	laser.set_pos(ship.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	ship.get_parent().add_child(laser)
	laser.change_speed(ship.speed)

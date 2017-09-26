extends Node


# This node is intended to take care of everything related to the ships except
# movement: shooting, shields/life, ..


const MAX_LIFE = 100
const MAX_SHIELDS = 100
const MAX_PROPULSION_CHARGE = 1.0
const MAX_PROPULSION_SPD_CHANGE = 20
const RELOAD_TIME = 0.2

var _physics

export var _life = 100
export var _shields = 100
var _reload_countdown = 0
var _propulsion_charge = 0

var _shooting = false
var _shooting_angle = 0
var _charging_propulsion = false

func _ready():
	set_process(true)
	add_to_group("ships")
	_physics = get_node("BodyPhysics")
	_life = MAX_LIFE
	_shields = MAX_SHIELDS

func _process(delta):
	if _shooting and _reload_countdown <= 0:
		shoot()
	if _reload_countdown > 0:
		_reload_countdown -= delta
	
	if _charging_propulsion and _propulsion_charge < MAX_PROPULSION_CHARGE :
		_propulsion_charge += delta*0.2

func shooting():
	_shooting = true
	_shooting_angle = get_rot()

func shooting_to(target_pos):
	_shooting = true
	var distance = get_pos() - target_pos
	_shooting_angle = distance.angle() + PI/2

func stop_shooting():
	_shooting = false

func hurt(damage):
	if _shields > 0:
		if damage <= _shields:
			_shields -= damage
			return
		else:
			damage -= _shields
			_shields = 0

	_life -= damage
	if _life <= 0:
		die()

func die():
	queue_free()

func start_charging_propulsion():
	_charging_propulsion = true

func propulsion():
	_charging_propulsion = false
	var speed_impulse = pow(_propulsion_charge,2)*MAX_PROPULSION_SPD_CHANGE
	_physics.speed_impulse(speed_impulse)
	_propulsion_charge = 0.0

func shoot():
	_reload_countdown = RELOAD_TIME
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_scale(Vector2(0.4, 0.4))
	laser.set_rot(_shooting_angle)
	laser.set_pos(get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	get_parent().add_child(laser)
	laser.get_node("BodyPhysics").change_speed(_physics.get_speed())

func are_shields_up():
	return _shields > 0

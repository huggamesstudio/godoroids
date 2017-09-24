extends Node


const MAX_LIFE = 100
const RELOAD_TIME = 0.2

var _head
var _physics

export var _life = 100

var _shooting = false
var _shooting_angle = 0
var _reload_countdown = 0

func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	
	set_fixed_process(true)


func _fixed_process(delta):

	if _shooting and _reload_countdown <= 0:
		shoot()
	if _reload_countdown > 0:
		_reload_countdown -= delta

func shooting():
	_shooting = true
	_shooting_angle = _head.get_rot()

func shooting_to(target_pos):
	_shooting = true
	var distance = _head.get_pos() - target_pos
	_shooting_angle = distance.angle() + PI/2

func stop_shooting():
	_shooting = false

func shoot():
	_reload_countdown = RELOAD_TIME
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_rot(_shooting_angle)
	laser.set_pos(_head.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	_head.get_parent().get_parent().get_node("Shoots").add_child(laser)
	laser.get_node("BodyPhysics").change_speed(_physics.get_speed())

func hurt(damage):
	_life -= damage
	if _life <= 0:
		die();

func die():
	_head.queue_free()

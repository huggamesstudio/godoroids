extends Node

const RELOAD_TIME = 0.2

var _head
var _physics

var _reload_countdown = 0
var id

export var quality_tier = 1 #From 1 to 5, being 5 the best weapong

func _ready():
	set_fixed_process(true)
	_head = get_parent().get_parent()
	_physics = _head.get_node("BodyPhysics")
	id = "lasergun"

func _fixed_process(delta):
	if _reload_countdown > 0:
		_reload_countdown -= delta

func shoot(target_ref, shooting_angle):
	if _reload_countdown > 0:
		return
	
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_scale(Vector2(0.4, 0.4))
	var dispersion_angle = PI/9/quality_tier
	var gun_inaccuracy_deviation = (randf()-0.5)*dispersion_angle
	laser.set_rot(shooting_angle+gun_inaccuracy_deviation)
	laser.set_pos(_head.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*50)
	_head.get_parent().add_child(laser)
	if _head.has_node("Team") and laser.has_node("Team"):
		laser.get_node("Team").set_team(_head.get_node("Team").get_team())
	laser.get_node("BodyPhysics").change_speed(_physics.get_speed())
	ResourcesManager.SAMPLE_PLAYER.play("laser")
	
	_reload_countdown = RELOAD_TIME

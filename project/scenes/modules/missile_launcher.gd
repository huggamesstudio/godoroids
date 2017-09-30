extends Node

const RELOAD_TIME = 1

var _head
var _physics

var _reload_countdown = 0

export var quality_tier = 1 #From 1 to 5, being 5 the best weapong

func _ready():
	set_fixed_process(true)
	_head = get_parent().get_parent()
	_physics = _head.get_node("BodyPhysics")

func _fixed_process(delta):
	if _reload_countdown > 0:
		_reload_countdown -= delta

func shoot(shooting_angle):
	if _reload_countdown > 0:
		return
	
	var missile = load("res://scenes/entities/missile.tscn").instance()
	missile.set_scale(Vector2(0.6, 0.6))
	missile.set_rot(shooting_angle)
	missile.set_pos(_head.get_pos()+Vector2(cos(missile.get_rot()),-sin(missile.get_rot()))*50)
	
	var red_ships = get_tree().get_nodes_in_group("RedTeam")
	if red_ships.size() > 0:
		var target = red_ships[0]
		missile.set_target(target)
	
	_head.get_parent().add_child(missile)
	missile.get_node("BodyPhysics").change_speed(_physics.get_speed())

	_reload_countdown = RELOAD_TIME

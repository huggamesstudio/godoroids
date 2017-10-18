extends Node

const RELOAD_TIME = 1

var _head
var _physics

var _reload_countdown = 0
var id

export var quality_tier = 1 #From 1 to 5, being 5 the best weapong

func _ready():
	set_fixed_process(true)
	_head = get_parent().get_parent()
	_physics = _head.get_node("BodyPhysics")
	id = "missile_launcher"

func _fixed_process(delta):
	if _reload_countdown > 0:
		_reload_countdown -= delta

func shoot(target_ref, shooting_angle):
	if _reload_countdown > 0:
		return
	
	var missile = load("res://scenes/entities/missile.tscn").instance()
	missile.set_scale(Vector2(0.6, 0.6))
	missile.set_rot(shooting_angle)
	missile.set_pos(_head.get_pos()+Vector2(cos(missile.get_rot()),-sin(missile.get_rot()))*50)
	

	if target_ref and target_ref.get_ref():
		missile.set_target(target_ref.get_ref())
	
	_head.get_parent().add_child(missile)
	missile.get_node("BodyPhysics").change_speed(_physics.get_speed())
	ResourcesManager.SAMPLE_PLAYER.play("missile")

	_reload_countdown = RELOAD_TIME

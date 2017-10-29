extends Node


var BASE_SPEED = 5
var BASE_DAMAGE = 20
var _life_span = 10

var _physics
var _engines
var _team

var _target_ref

func _ready():
	_physics = get_node("BodyPhysics")
	_engines = get_node("Engines")
	_team = get_node("Team")
	
	set_fixed_process(true)
	var rotation = get_rot()

func _fixed_process(delta):
	if (_target_ref and _target_ref.get_ref()):
    	_pursue_target(_target_ref.get_ref())
	
	var colliders = get_overlapping_bodies()
	for collider in colliders:
		if collider.has_method("hurt"):
			collider.hurt(BASE_DAMAGE, _team.get_team())
		var explosion = load("res://scenes/animations/laser_explosion_anim.tscn").instance()
		explosion.set_scale(Vector2(2, 2))
		explosion.set_pos(get_pos())
		get_parent().add_child(explosion)
		queue_free()
	
	_life_span -= delta
	if _life_span < 0:
		queue_free()

func set_target(target):
	_target_ref = weakref(target)

func _pursue_target(target_ship):
	var distance_vec_normalized = (target_ship.get_pos() - get_pos()).normalized()
	var distance_module = (target_ship.get_pos() - get_pos()).length()
	var angle_towards_target = distance_vec_normalized.angle() - PI/2
	
	_engines.orienting_to(angle_towards_target, PI/24)
	var target_speed_along_axis = target_ship.get_node("BodyPhysics").get_speed().dot(distance_vec_normalized)
	
	_engines.reduce_speed_along_direction(distance_vec_normalized.tangent(), 0.1)

	_engines.match_speed(_physics.get_speed(), BASE_SPEED, distance_vec_normalized, 0.02)
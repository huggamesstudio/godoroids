extends Node


var _physics
var _team

var BASE_SPEED = 10
var BASE_DAMAGE = 10
var _life_span = 0.5


func _ready():
	_physics = get_node("BodyPhysics")
	_team = get_node("Team")
	
	set_fixed_process(true)
	var rotation = get_rot()
	_physics.change_speed(Vector2(cos(rotation), -sin(rotation))*BASE_SPEED)
	
func _fixed_process(delta):
	var colliders = get_overlapping_bodies()
	for collider in colliders:
		if collider.has_method("hurt"):
			collider.hurt(BASE_DAMAGE, _team.get_team())
		var explosion = load("res://scenes/animations/laser_explosion_anim.tscn").instance()
		explosion.set_scale(Vector2(0.4, 0.4))
		explosion.set_pos(get_pos())
		get_parent().add_child(explosion)
		queue_free()
	
	_life_span -= delta
	if _life_span < 0:
		queue_free()

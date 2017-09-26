extends Node


var _head
var _physics

var BASE_SPEED = 10
var BASE_DAMAGE = 10
var _life_ticks = 60


func _ready():
	_head = get_parent()
	_physics = _head.get_node("BodyPhysics")
	
	set_fixed_process(true)
	var rotation = _head.get_rot()
	_physics.change_speed(Vector2(cos(rotation), -sin(rotation))*BASE_SPEED)
	
func _fixed_process(delta):
	var colliders = _head.get_overlapping_bodies()
	for collider in colliders:
		if collider.has_method("hurt"):
			collider.hurt(BASE_DAMAGE)
		var explosion = load("res://scenes/animations/laser_explosion_anim.tscn").instance()
		explosion.set_scale(Vector2(0.4, 0.4))
		explosion.set_pos(_head.get_pos())
		_head.get_parent().add_child(explosion)
		_head.queue_free()
	
	_life_ticks -= 1
	if _life_ticks < 1:
		_head.queue_free()

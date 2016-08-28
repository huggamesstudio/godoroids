extends Node


var _head

var BASE_SPEED = 10
var BASE_DAMAGE = 10
var _life_ticks = 60


func _ready():
	_head = get_parent()
	
	set_fixed_process(true)
	var rotation = _head.get_rot()
	_head.change_speed(Vector2(cos(rotation), -sin(rotation))*BASE_SPEED)
	
func _fixed_process(delta):
	if _head.is_colliding():
		var collider_systems = _head.get_collider().get_node("Systems")
		if collider_systems and collider_systems.has_method("hurt"):
			collider_systems.hurt(BASE_DAMAGE)
		_head.queue_free()
	
	_life_ticks -= 1
	if _life_ticks < 1:
		_head.queue_free()
		



extends Node


var _physics

var BASE_SPEED = 50
var BASE_DAMAGE = 10
var _life_ticks = 60


func _ready():
	_physics = get_node("BodyPhysics")
	
	set_fixed_process(true)
	var rotation = get_rot()
	_physics.change_speed(Vector2(cos(rotation), -sin(rotation))*BASE_SPEED)
	
func _fixed_process(delta):
	var colliders = get_overlapping_bodies()
	for collider in colliders:
		if collider.has_method("hurt"):
			collider.hurt(BASE_DAMAGE)
		var explosion = load("res://scenes/animations/laser_explosion_anim.tscn").instance()
		explosion.set_scale(Vector2(1, 1))
		explosion.set_pos(get_pos())
		get_parent().add_child(explosion)
		queue_free()
	
	_life_ticks -= 1
	if _life_ticks < 1:
		queue_free()

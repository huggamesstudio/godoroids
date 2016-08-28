
extends Node

var laser

var BASE_SPEED = 10
var BASE_DAMAGE = 10
var life_ticks = 60
var vector_speed = Vector2(0,0)


func _ready():
	laser = get_parent()
	
	set_fixed_process(true)
	var rotation = laser.get_rot()
	laser.change_speed(Vector2(cos(rotation), -sin(rotation))*BASE_SPEED)
	
func _fixed_process(delta):
	if laser.is_colliding():
		var collider_systems = laser.get_collider().get_node("Systems")
		if collider_systems and collider_systems.has_method("hurt"):
			collider_systems.hurt(BASE_DAMAGE)
		laser.queue_free()
	
	life_ticks -= 1
	if life_ticks < 1:
		laser.queue_free()
		



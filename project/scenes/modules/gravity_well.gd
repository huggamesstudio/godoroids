extends Node


# When this node is attached as child to a DynamicBody2D (KineticBody2D+dynamic_body.gd)
# it enables gravity for the parent. The parent will now pull other gravity wells
# (depending on the mass) and will be pull by others (unless gravity_atracted is set to false)


var _head
var _physics

const K = 5.0
const EARTH_MASS = 15000.0

export var _mass = 1.0
export var _gravity_atracted = true

func _ready():
	set_fixed_process(true)
	_head = get_parent()
	if _is_heavy():
		add_to_group("heavies")
	
func gravity(target_pos):
	var r = target_pos - _head.get_pos()
	if r.length() == 0:
		return Vector2(0, 0)
	var acceleration = -K*EARTH_MASS*_mass*r/pow(r.length(),3)
	return acceleration

func _fixed_process(delta):
	var heavies = get_tree().get_nodes_in_group("heavies")
	for heavy in heavies:
		if heavy==self:
			continue
		var heavy_physics = heavy.get_parent().get_node("BodyPhysics")
		if heavy_physics and heavy_physics.has_method("change_speed"):
			var a = gravity(heavy.get_parent().get_pos())
			heavy_physics.change_speed(a*delta)

func _is_heavy():
	return _gravity_atracted


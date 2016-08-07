const k = 50000.0
export var mass = 1.0
export var gravity_atracted = true

func _ready():
	self.set_fixed_process(true)
	if _is_heavy():
		add_to_group("heavies")
	
func gravity(target_pos):
	var r = target_pos - self.get_parent().get_pos()
	var acceleration = -k*mass*r/pow(r.length(),3)
	return acceleration

func _fixed_process(delta):
	var heavies = self.get_tree().get_nodes_in_group("heavies")
	for heavy in heavies:
		if heavy==self:
			continue
		if heavy.get_parent().has_method("change_speed"):
			var a = gravity(heavy.get_parent().get_pos())
			heavy.get_parent().change_speed(a*delta)

func _is_heavy():
	return self.gravity_atracted


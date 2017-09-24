extends CanvasLayer

var ARROW_DISTANCE = 450

var _life_shield_gauge
var _arrow_box
var _arrows
var _ref_actor
var _other_actors
var _camera

func _ready():
	_life_shield_gauge = get_node("LifeShieldContainer/LifeShield")
	_arrow_box = get_node("RadarArrowBox")
	_arrows = []
	_ref_actor = null
	_other_actors = []
	_camera = null
	set_process(true)

func set_camera(camera):
	_camera = camera

func set_reference_actor(actor):
	_ref_actor = actor

	# Follow the reference actor with the camera
	var current_camera_parent = _camera.get_parent()
	current_camera_parent.remove_child(_camera)
	_ref_actor.add_child(_camera)

func _update_other_actors():
	var ship_actors = get_parent().get_node("Actors/Ships").get_children()
	var reference_actor_team_number = _ref_actor.get_node("Team").get_team()
	for actor in ship_actors:
		var actor_team = actor.get_node("Team")
		if not actor_team:
			continue
		var actor_team_numer = actor_team.get_team()
		if actor_team_numer == reference_actor_team_number:
			continue
		_other_actors.append(actor)

func _process(delta):
	if not _ref_actor:
		return

	var ref_actor_life = [_ref_actor.get_node("Systems")._life, _ref_actor.get_node("Systems").MAX_LIFE]
	var ref_actor_shields = [_ref_actor.get_node("Systems")._shields, _ref_actor.get_node("Systems").MAX_SHIELDS]
	_life_shield_gauge.set_inner_value(float(ref_actor_life[0])/float(ref_actor_life[1]))
	_life_shield_gauge.set_outer_value(float(ref_actor_shields[0])/float(ref_actor_shields[1]))

	_update_other_actors()

	var arrow_size_delta = _arrows.size() - _other_actors.size()
	if arrow_size_delta > 0:
		var left_arrow = null
		for _ in range(arrow_size_delta):
			left_arrow = _arrows.pop_back()
			left_arrow.queue_free()
	elif arrow_size_delta < 0:
		var arrow_scene = load("res://scenes/animations/radar_arrow.tscn")
		var arrow_instance = null
		for _ in range(-arrow_size_delta):
			arrow_instance = arrow_scene.instance()
			_arrow_box.add_child(arrow_instance)
			_arrows.append(arrow_instance)

	var other = null
	var ref_2_other = null
	var ship_index = 0
	for arrow in _arrows:
		other = _other_actors[ship_index]
		ref_2_other = (other.get_pos()-_ref_actor.get_pos())
		if ref_2_other.length() < 500:
			arrow.hide()
		else:
			arrow.show()
			arrow.set_rot(ref_2_other.angle()-deg2rad(90))
			arrow.set_pos(Vector2(810,390)+(ref_2_other.normalized()*ARROW_DISTANCE))
		ship_index += 1


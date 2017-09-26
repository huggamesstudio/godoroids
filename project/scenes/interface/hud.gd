extends CanvasLayer

var ARROW_DISTANCE = 450

var _camera
var _life_shield_gauge
var _ref_actor
var _other_actors
var _arrow_box
var _arrows
var _arrow_scene = load("res://scenes/animations/radar_arrow.tscn")

func _ready():
	_camera = null
	_ref_actor = null
	_other_actors = []
	_life_shield_gauge = get_node("LifeShieldContainer/LifeShield")
	_arrow_box = get_node("RadarArrowBox")
	_arrows = []

	set_process(true)

func set_camera(camera):
	_camera = weakref(camera)

func set_reference_actor(actor):
	_ref_actor = weakref(actor)

	if not _camera:
		return
	else:
		var camera = _camera.get_ref()
		if not camera:
			return
		else:
			var current_camera_parent = camera.get_parent()
			current_camera_parent.remove_child(camera)
			actor.add_child(camera)

func _process(delta):
	var ref_actor = null
	if not _ref_actor:
		return
	else:
		ref_actor = _ref_actor.get_ref()
		if not ref_actor:
			return

	var camera = null
	if not _camera:
		return
	else:
		camera = _camera.get_ref()
		if not camera:
			return

	if ref_actor:
		var ref_actor_life = float(ref_actor.life)
		var ref_actor_life_max = float(ref_actor.MAX_LIFE)
		var ref_actor_shields = float(ref_actor.shields)
		var ref_actor_shields_max = float(ref_actor.MAX_SHIELDS)
		_life_shield_gauge.set_inner_value(ref_actor_life/ref_actor_life_max)
		_life_shield_gauge.set_outer_value(ref_actor_shields/ref_actor_shields_max)
	else:
		_life_shield_gauge.set_inner_value(1)
		_life_shield_gauge.set_outer_value(1)

	_update_other_actors()
	_update_arrow_list()

	# Arrow positioning.

	var other = null
	var ref_2_other = null
	var ref_2_other_angle = 0
	var ship_index = 0
	for arrow in _arrows:

		# We will show all the arrows here and hide it later if they are on range.
		arrow.show()

		# Get information about arrow's target.
		other = _other_actors[ship_index]
		ref_2_other = (other.get_pos()-ref_actor.get_pos())
		ref_2_other_angle = ref_2_other.angle()

		# Turn the arrow sprite in the correct direction.
		arrow.set_rot(ref_2_other_angle-deg2rad(90))

		# Arrows can show in 4 diferent sides in a box (ranges).
		# These are the angle limits for each range.
		var tetha3 = atan2(_arrow_box.get_size().x, _arrow_box.get_size().y)
		var tetha4 = -tetha3
		var tetha2 = deg2rad(180) - tetha3
		var tetha1 = -tetha2

		# Calculate the screen space vector for the arrow.
		var xx = 0
		var yy = 0
		if ref_2_other_angle > tetha3 and ref_2_other_angle <= tetha2:
			xx = _arrow_box.get_size().x/2
			yy = xx * tan(deg2rad(90)-ref_2_other_angle)
		elif ref_2_other_angle > tetha1 and ref_2_other_angle <= tetha4:
			xx = -_arrow_box.get_size().x/2
			yy = xx * tan(deg2rad(90)-ref_2_other_angle)
		elif ref_2_other_angle > tetha4 and ref_2_other_angle <= tetha3:
			yy = _arrow_box.get_size().y/2
			xx = -yy * tan(deg2rad(180)-ref_2_other_angle)
		else:
			yy = -_arrow_box.get_size().y/2
			xx = -yy * tan(deg2rad(180)-ref_2_other_angle)
		arrow.set_pos((_arrow_box.get_size()/2)+Vector2(xx,yy))

		# If the arrow's target is inside the screen hide the arrow.
		if ref_2_other.length() < (Vector2(xx, yy) * camera.get_zoom()).length():
			arrow.hide()

		ship_index += 1

func _update_other_actors():
	_other_actors = []

	var ref_actor = null
	if not _ref_actor:
		return
	else:
		ref_actor = _ref_actor.get_ref()
		if not ref_actor:
			return

	var reference_actor_team_number = 0
	var reference_actor_team = ref_actor.get_node("Team")
	if reference_actor_team:
		reference_actor_team_number = reference_actor_team.get_team()

	var ship_actors = get_tree().get_nodes_in_group("ships")

	var actor_team = null
	var actor_team_numer = 0
	for actor in ship_actors:
		actor_team = actor.get_node("Team")
		if not actor_team:
			_other_actors.append(actor)
			continue
		actor_team_numer = actor_team.get_team()
		if actor_team_numer == reference_actor_team_number:
			continue
		_other_actors.append(actor)

func _update_arrow_list():
	var arrow_size_delta = _arrows.size() - _other_actors.size()
	if arrow_size_delta > 0:
		var left_arrow = null
		for _ in range(arrow_size_delta):
			left_arrow = _arrows.pop_back()
			if left_arrow:
				left_arrow.queue_free()
	elif arrow_size_delta < 0:
		var arrow_instance = null
		for _ in range(-arrow_size_delta):
			arrow_instance = _arrow_scene.instance()
			_arrow_box.add_child(arrow_instance)
			_arrows.append(arrow_instance)

extends CanvasLayer

var ARROW_SIZE_INITIAL = 0.5
var ARROW_SIZE_INC_DISTANCE = 2500
var ARROW_SIZE_INC_VALUE = 0.1
var ARROW_SIZE_MAXIMUN = 3

var _camera
var _life_shield_gauge
var _ref_actor
var _other_actors
var _arrow_box
var _arrows
var _arrow_scene = load("res://scenes/animations/radar_arrow.tscn")
var _boost

var _target_indicator_frame

func _ready():
	_camera = null
	_ref_actor = null
	_other_actors = []
	_life_shield_gauge = get_node("LifeShieldContainer/LifeShield")
	_arrow_box = get_node("RadarArrowBox")
	_arrows = []
	_boost = get_node("BoostIndicator/BoostImage")

	set_process(true)

func set_camera(camera):
	_camera = weakref(camera)

func set_reference_actor(actor):
	_ref_actor = weakref(actor)
	
	if not _camera or not _camera.get_ref():
		return
	var camera = _camera.get_ref()

	var current_camera_parent = camera.get_parent()
	current_camera_parent.remove_child(camera)
	actor.add_child(camera)
	
	get_node("WeaponsSelectionContainer").set_weapon_indicators(actor.get_node("Weapons").get_children())

func _process(delta):
	if not _ref_actor or not _ref_actor.get_ref():
		return
	var actor = _ref_actor.get_ref()

	if not _camera or not _camera.get_ref():
		return
	var camera = _camera.get_ref()

	var actor_life = float(actor.life)
	var actor_life_max = float(actor.MAX_LIFE)
	var actor_shields = float(actor.shields)
	var actor_shields_max = float(actor.MAX_SHIELDS)
	_life_shield_gauge.set_inner_value(actor_life/actor_life_max)
	_life_shield_gauge.set_outer_value(actor_shields/actor_shields_max)

	var actor_boost = actor.get("propulsion_charge")
	if actor_boost:
		_boost.set_pos(Vector2((150*actor_boost)/2,0))
		_boost.set_region_rect(Rect2(0,0,150*actor_boost,50))
	else:
		_boost.set_pos(Vector2(0,0))
		_boost.set_region_rect(Rect2(0,0,0,50))

	get_node("WeaponsSelectionContainer").update_weapon_indicator(actor.get_selected_weapon())
	_update_target_indicator(camera, actor.target_ref)
	_update_other_actors(actor)
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
		ref_2_other = (other.get_pos()-actor.get_pos())
		ref_2_other_angle = ref_2_other.angle()

		# Scale the arrow graph base on distance
		var arrow_scale = ARROW_SIZE_INITIAL
		arrow_scale += (ref_2_other.length() / ARROW_SIZE_INC_DISTANCE) * ARROW_SIZE_INC_VALUE
		if arrow_scale > ARROW_SIZE_MAXIMUN:
			arrow_scale = ARROW_SIZE_MAXIMUN
		arrow.set_scale(Vector2(arrow_scale, arrow_scale))

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

func _update_other_actors(actor):
	_other_actors = []

	var reference_actor_team_number = 0
	var reference_actor_team = actor.get_node("Team")
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

func _update_target_indicator(camera, target_ref):
	if !target_ref or !target_ref.get_ref():
		return
	var INDICATOR_SIZE = 30
	if !_target_indicator_frame:
		_target_indicator_frame = Sprite.new()
		_target_indicator_frame.set_texture(load("res://resources/images/round_icon_frame.png"))
		add_child(_target_indicator_frame)
		var scale = Vector2(INDICATOR_SIZE, INDICATOR_SIZE)/_target_indicator_frame.get_texture().get_size()
		_target_indicator_frame.set_scale(Vector2(scale))
	var targets = get_tree().get_nodes_in_group("ships")
	var target_index = targets.find(target_ref.get_ref())
	if target_index > -1:
		_target_indicator_frame.show()
		var camara_position = camera.get_parent().get_pos()
		var resolution = Vector2(Globals.get("display/width"),Globals.get("display/height"))
		var target_position_on_camera = targets[target_index].get_pos() - camara_position + resolution/2
		_target_indicator_frame.set_pos(target_position_on_camera)
	else:
		_target_indicator_frame.hide()

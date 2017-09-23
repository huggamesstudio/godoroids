extends CanvasLayer

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

	_update_other_actors()

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


extends Node2D

export var respawning_time = 5
export var max_objects = 1
export var can_spawn_player = false

export var disable = false
var _active

var _spawning_countdown
var _current_number_objects

export var scene = "res://scenes/entities/ship.tscn"

signal player_created

func _ready():
	set_fixed_process(true)
	_active = true
	_spawning_countdown = 0
	_current_number_objects = 0

func _fixed_process(delta):
	if _active == false or disable:
		return
	
	if _spawning_countdown <= 0:
		_spawning_countdown = 0
		spawn()
	else:
		_spawning_countdown -= delta

func spawn():
	var instance = load(scene).instance()
	instance.set_pos(get_pos())
	get_parent().add_child(instance)
	if has_node("Team") and instance.has_node("Team"):
		instance.get_node("Team").set_team(get_node("Team").get_team())
	if instance.has_node("AI") and can_spawn_player and (not Global.player1_ref or not Global.player1_ref.get_ref()):
		var player1_int = load("res://scenes/modules/player1_intelligence.tscn")
		instance.remove_child(instance.get_node("AI"))
		instance.add_child(player1_int.instance())
		var hud = load("res://scenes/interface/hud.tscn").instance()
		instance.add_child(hud)
		
		Global.player1_ref = weakref(instance)
		emit_signal("player_created")
	instance.connect("ship_destroyed", self, "start_respawning")
	
	_spawning_countdown = respawning_time
	_current_number_objects += 1
	if _current_number_objects >= max_objects:
		_active = false
	
func start_respawning():
	_current_number_objects -= 1
	if _current_number_objects < max_objects:
		_active = true
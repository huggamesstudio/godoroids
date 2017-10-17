extends Node2D

export var respawning_time = 5
export var max_objects = 1

var _active

var _spawning_countdown

export var scene = "res://scenes/entities/ship.tscn"

signal player_created

func _ready():
	set_fixed_process(true)
	_active = true
	_spawning_countdown = 0

func _fixed_process(delta):
	if _active == false:
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
	if instance.has_node("AI") and (not Global.player1_ref or not Global.player1_ref.get_ref()):
		var player1_int = load("res://scenes/modules/player1_intelligence.tscn")
		instance.remove_child(instance.get_node("AI"))
		instance.add_child(player1_int.instance())
		var hud = load("res://scenes/interface/hud.tscn").instance()
		instance.add_child(hud)
		
		Global.player1_ref = weakref(instance)
		instance.connect("player_dead", self, "start_respawning")
		emit_signal("player_created")
	

	_active = false
	
func start_respawning():
	_active = true
	_spawning_countdown = respawning_time
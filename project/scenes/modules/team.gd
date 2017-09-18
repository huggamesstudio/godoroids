extends Node

var _head


export var _team = 0


func _ready():
	_head = get_parent()
	set_team(_team)

func set_team(team):
	_head.remove_from_group(Global.TEAM[_team])
	_team = team
	_head.add_to_group(Global.TEAM[_team])
	var sprite = _head.get_node("TeamSprite")
	sprite.set_modulate(Global.TEAM_COLORS[_team])

func get_team():
	return _team;
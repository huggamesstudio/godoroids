extends Node

var _head
export var _team_number = 0


func _ready():
	_head = get_parent()
	_apply_team(_team_number)

func set_team(team_idx):
	_head.remove_from_group(Global.TEAM[_team_number])
	_apply_team(team_idx)

func _apply_team(team_idx):
	_team_number = team_idx
	_head.add_to_group(Global.TEAM[_team_number])
	if _head.has_node("Sprite"):
		var sprite = _head.get_node("Sprite")
		sprite.set_modulate(Global.TEAM_COLORS[_team_number])

func get_team():
	return _team_number
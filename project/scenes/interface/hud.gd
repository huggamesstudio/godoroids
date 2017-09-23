extends CanvasLayer

var _life_shield_gauge

func _ready():
	_life_shield_gauge = get_node("LifeShieldContainer/LifeShield")

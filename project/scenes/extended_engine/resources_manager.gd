extends Node


var WEAPON_IMAGES = { "lasergun": "lasergun_icon.png", "missile_launcher": "missile_launcher_icon.png"}

var SAMPLE_PLAYER

func _ready():
	SAMPLE_PLAYER = get_tree().get_root().get_node("Space").get_node("SamplePlayer")

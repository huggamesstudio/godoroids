extends Node

var currentScene = null
var PlayerName = "T-Rex"

func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
	Globals.set("GROUND_SIZE", Vector2(0,0))

func setScene(scene):
	currentScene.queue_free()
	var s = load(scene)
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)
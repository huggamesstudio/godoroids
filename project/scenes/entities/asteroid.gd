
extends Node

func _ready():
	var asteroid = get_parent()
	asteroid.add_to_group("asteroids")
	
	var sprite = asteroid.get_node("Sprite")
	var color = Color(randf(), randf(), randf())
	sprite.set_modulate(color)



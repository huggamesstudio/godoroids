
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	add_to_group("asteroids")
	
	var sprite = self.get_node("Sprite")
	var color = Color(randf(), randf(), randf())
	sprite.set_modulate(color)



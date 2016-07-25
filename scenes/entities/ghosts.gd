
extends Node2D


func _ready():
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if i==0 and j==0:
				continue
			var ghost = self.get_node("ModelSprite").duplicate()
			self.add_child(ghost)
			ghost.set_pos(Vector2(i*100,j*100))
			ghost.set_offset(Vector2(i*100,j*100))



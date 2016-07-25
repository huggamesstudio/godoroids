
extends KinematicBody2D

var SPEED = 10
var LIFE_TICKS = 60

func _ready():
	self.set_fixed_process(true)
	
func _fixed_process(delta):
	var rotation = self.get_rot()
	var vector_speed = Vector2(cos(rotation), -sin(rotation))*self.SPEED
	move(vector_speed)
	self.LIFE_TICKS -= 1
	if self.LIFE_TICKS < 1:
		self.queue_free()
	



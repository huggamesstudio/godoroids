
extends KinematicBody2D

var BASE_SPEED = 10
var LIFE_TICKS = 60
var vector_speed = Vector2(0,0)

func _ready():
	self.set_fixed_process(true)
	var rotation = self.get_rot()
	self.vector_speed = Vector2(cos(rotation), -sin(rotation))*self.BASE_SPEED
	
func _fixed_process(delta):
	move(self.vector_speed)
	self.LIFE_TICKS -= 1
	if self.LIFE_TICKS < 1:
		self.queue_free()
	
func change_speed(extra_speed):
	self.vector_speed += extra_speed


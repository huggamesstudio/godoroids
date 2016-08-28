
extends AnimatedSprite

var _countdown = 0.5

func _ready():
	set_process(true)

func _process(delta):
	_countdown -= delta
	if _countdown <= 0:
		queue_free()
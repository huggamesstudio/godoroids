extends Node

var BLINK_PHASE_LEN = 20
var SPRITE_SIZE_XY = 100

var _dot
var _inner
var _outer
var _border

var _dot_blinking = false
var _dot_blinking_phase = 0

func _ready():
	set_process(true)
	
	_dot = get_node("Dot")
	_inner = get_node("Inner")
	_outer = get_node("Outer")
	_border = get_node("Border")

func enable_blink(enable=true):
	if enable and not _dot_blinking:
		_dot_blinking = true
		_dot_blinking_phase = 0

	if not enable and _dot_blinking:
		_dot_blinking = true
		_dot_blinking_phase = 0
		_dot.hide()

func modulate_blink(color):
	_dot.set_modulate(color)

func set_inner_value(value):
	if value >= 0 and value <= 1:
		value = -(value-1)
		_inner.set_region_rect(Rect2(
			0,
			SPRITE_SIZE_XY*value,
			SPRITE_SIZE_XY,
			SPRITE_SIZE_XY-(SPRITE_SIZE_XY*value)
		))
		_inner.set_pos(Vector2(0, (SPRITE_SIZE_XY/2)*value))

func modulate_inner(color):
	_inner.set_modulate(color)

func set_outer_value(value):
	if value >= 0 and value <= 1:
		value = -(value-1)
		_outer.set_region_rect(Rect2(
			0,
			SPRITE_SIZE_XY*value,
			SPRITE_SIZE_XY,
			SPRITE_SIZE_XY-(SPRITE_SIZE_XY*value)
		))
		_outer.set_pos(Vector2(0, (SPRITE_SIZE_XY/2)*value))

func modulate_outer(color):
	_outer.set_modulate(color)

func modulate_border(color):
	_border.set_modulate(color)

func _process(delta):
	if _dot_blinking:
		_dot_blinking_phase += 1
		if _dot_blinking_phase > BLINK_PHASE_LEN:
			_dot_blinking_phase = -BLINK_PHASE_LEN
		if _dot_blinking_phase < 0:
			_dot.hide()
		else:
			_dot.show()

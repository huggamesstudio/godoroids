extends Node2D

const INDICATOR_SIZE = 50

var _weapons
var _indicator_frame

func _ready():
	pass

func set_weapon_indicators(weapons):
	for node in get_children():
		node.queue_free()

	_weapons = weapons
	var counter = 0
	for weapon in weapons:
		var image_name = ResourcesManager.WEAPON_IMAGES[weapon.id]
		var weapon_sprite = Sprite.new()
		weapon_sprite.set_texture(load("res://resources/images/"+image_name))
		var scale = Vector2(INDICATOR_SIZE, INDICATOR_SIZE)/weapon_sprite.get_texture().get_size()
		weapon_sprite.set_scale(Vector2(scale))
		weapon_sprite.set_pos(Vector2((INDICATOR_SIZE+1)*counter, 0))
		add_child(weapon_sprite)
		
		counter += 1

func update_weapon_indicator(selected_weapon):
	if !_indicator_frame:
		_indicator_frame = Sprite.new()
		_indicator_frame.set_texture(load("res://resources/images/icon_frame.png"))
		add_child(_indicator_frame)
		var scale = Vector2(INDICATOR_SIZE, INDICATOR_SIZE)/_indicator_frame.get_texture().get_size()
		_indicator_frame.set_scale(Vector2(scale))
	var weapon_index = _weapons.find(selected_weapon)
	if weapon_index > -1:
		_indicator_frame.show()
		_indicator_frame.set_pos(Vector2((INDICATOR_SIZE+1)*weapon_index, 0))
	else:
		_indicator_frame.hide()
	
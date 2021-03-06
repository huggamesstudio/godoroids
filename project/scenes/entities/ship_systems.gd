extends Node


# This node is intended to take care of everything related to the ships except
# movement: shooting, shields/life, ..


const MAX_LIFE = 100
const MAX_SHIELDS = 100
const MAX_PROPULSION_CHARGE = 1.0
const MAX_PROPULSION_SPD_CHANGE = 20

var _physics

export var life = 100
export var shields = 100
var propulsion_charge = 0

var _selected_weapon
var target_ref

var _shooting = false
var _is_shooting_direction_dettached = false
var _shooting_angle = 0
var _charging_propulsion = false

signal ship_destroyed

func _ready():
	set_process(true)
	add_to_group("ships")
	_physics = get_node("BodyPhysics")
	life = MAX_LIFE
	shields = MAX_SHIELDS

func _process(delta):
	if _shooting:
		shoot()

	if _charging_propulsion and propulsion_charge < MAX_PROPULSION_CHARGE :
		propulsion_charge += delta*0.2

func straight_shooting():
	_shooting = true
	_is_shooting_direction_dettached = false
	_shooting_angle = get_rot()

func shooting_to(target_pos):
	_shooting = true
	_is_shooting_direction_dettached = true
	var distance = get_pos() - target_pos
	_shooting_angle = distance.angle() + PI/2

func stop_shooting():
	_shooting = false

func hurt(damage, team_idx):
	if shields > 0:
		if damage <= shields:
			shields -= damage
			return
		else:
			damage -= shields
			shields = 0

	life -= damage
	if life <= 0:
		die(team_idx)

func die(team_idx):
	if has_node("Player1Input"):
		if has_node("Camera"):
			var camera = Global.camera
			remove_child(camera)
			get_tree().get_root().add_child(camera)
	emit_signal("ship_destroyed")
	Global.TEAM_SCORES[team_idx] += 1
	queue_free()

func start_charging_propulsion():
	_charging_propulsion = true

func propulsion():
	_charging_propulsion = false
	var speed_impulse = pow(propulsion_charge,2)*MAX_PROPULSION_SPD_CHANGE
	_physics.speed_impulse(speed_impulse)
	propulsion_charge = 0.0

func shoot():
	if _selected_weapon:
		var angle = get_rot()
		if _is_shooting_direction_dettached:
			angle = _shooting_angle
		_selected_weapon.shoot(target_ref, angle)

func change_weapons():
	var weapon_nodes = get_node("Weapons").get_children()
	if weapon_nodes.size() == 0:
		return

	var index_current_weapon = weapon_nodes.find(_selected_weapon)
	if index_current_weapon < 0 or index_current_weapon == weapon_nodes.size() - 1:
		_selected_weapon = weapon_nodes[0]
	else:
		_selected_weapon = weapon_nodes[index_current_weapon+1]

func select_weapon(weapon_id):
	var weapon_nodes = get_node("Weapons").get_children()
	if weapon_nodes.size() == 0:
		return

	for weapon in weapon_nodes:
		if weapon.id == weapon_id:
			_selected_weapon = weapon
			return

func get_selected_weapon():
	return _selected_weapon

func change_target():
	var ships = get_tree().get_nodes_in_group("ships")
	var index_current_target = -1
	if target_ref and target_ref.get_ref():
		index_current_target = ships.find(target_ref.get_ref())
	var i = index_current_target + 1
	var counter_ships_own_team = 0
	while(true):
		if i >= ships.size():
			i = 0
		var ship = ships[i]
		if ship.get_node("Team") and get_node("Team") and ship.get_node("Team").get_team() == get_node("Team").get_team():
			counter_ships_own_team += 1
			if counter_ships_own_team == ships.size():
				return
			i += 1
		else:
			target_ref = weakref(ships[i])
			break

func set_target(target):
	target_ref = weakref(target)

func are_shields_up():
	return shields > 0

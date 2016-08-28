extends Node

const MAX_LIFE = 100
const RELOAD_TIME = 0.2

var cruiser

export var life = 100


var shooting = false
var shooting_angle = 0
var reload_countdown = 0

func _ready():
	cruiser = get_parent()
	
	set_fixed_process(true)


func _fixed_process(delta):

	if shooting and reload_countdown <= 0:
		shoot()
	if reload_countdown > 0:
		reload_countdown -= delta

func shooting():
	shooting = true
	shooting_angle = cruiser.get_rot()

func shooting_to(target_pos):
	shooting = true
	var distance = cruiser.get_pos() - target_pos
	shooting_angle = distance.angle() + PI/2

func stop_shooting():
	shooting = false

func shoot():
	reload_countdown = RELOAD_TIME
	var laser = load("res://scenes/entities/laser.tscn").instance()
	laser.set_rot(shooting_angle)
	laser.set_pos(cruiser.get_pos()+Vector2(cos(laser.get_rot()),-sin(laser.get_rot()))*100)
	cruiser.get_parent().add_child(laser)
	laser.change_speed(cruiser.speed)

func hurt(damage):
	life -= damage
	if life <= 0:
		die();

func die():
	cruiser.queue_free()

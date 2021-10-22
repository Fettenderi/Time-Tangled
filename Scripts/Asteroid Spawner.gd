extends Node2D

export var dx = true
export var delay = 3.0
export var time = 3.0
onready var timer = $Timer
var asteroid1 = load("res://Scenes/Objects/Asteroid1.tscn")
var asteroid2 = load("res://Scenes/Objects/Asteroid2.tscn")
var asteroid3 = load("res://Scenes/Objects/Asteroid3.tscn")
var asteroid4 = load("res://Scenes/Objects/Asteroid4.tscn")
var donut = load("res://Scenes/Objects/Donut.tscn")
var type = 0
var spawn = true
var a = null

func _ready():
	timer.set_wait_time(delay)

func t_spawn():
	timer.set_wait_time(time)
	randomize()
	type = randi() % 101
	if type in range(0,40):
		a = asteroid4.instance()
	elif type in range(41,70):
		a = asteroid1.instance()
	elif type in range(71,93):
		a = asteroid2.instance()
	elif type in range(94,99):
		a = asteroid3.instance()
	else:
		a = donut.instance()
	
	a.position.y = rand_range(0,300)
	a.position.x = self.position.x
	a.spin = rand_range(0.01,0.1)
	if dx:
		a.dir = Vector2(1, rand_range(-0.6,0.6)).normalized()
	else:
		a.dir = Vector2(-1, rand_range(-0.6,0.6)).normalized()
	if spawn:
		get_parent().add_child(a)


func sx_on(_area):
	spawn = false
	PlayerStats.cardinality = "Left" if dx else "Right"

func sx_off(_area):
	spawn = true




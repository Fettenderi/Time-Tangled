extends Node2D

export var bullet_scene: PackedScene
export var min_rotation = 0
export var max_rotation = 360
export var number_of_bullets = 8
export var is_random = false
export var spawn_rate = 0.4
export var bullet_speed = 5.0
export var dir = Vector2(1,0)
export var log_to_console = false
export var oddness = false
export var spin = 0.0
export var var1: AudioStream
export var var2: AudioStream

onready var player = get_parent().get_parent().get_node("Player")
onready var stats = $Stats
onready var timer = $Timer
onready var blink_animation = $BlinkAnimation
onready var hit_sfx = $HitSfx
onready var burst_timer : PackedScene = preload("res://Scenes/Misc/ShootBurst.tscn")

var burst_instance : Node
var can_shoot : bool = true
var rotations = []
var odd = false
var hit_variant

func _ready():
	timer.wait_time = spawn_rate
	timer.start()
	if is_random:
		burst_instance = burst_timer.instance()
		add_child(burst_instance,true)
		burst_instance.start(5)
# warning-ignore:return_value_discarded
		burst_instance.connect("timeout",self,"burst_timeout")

func _process(delta):
	rotate(spin * delta)

func random_rotations():
	rotations = []
	for _i in range(0, number_of_bullets):
		rotations.append(rand_range(min_rotation, max_rotation))

func distributed_rotations():
	rotations = []
	for i in range(0, number_of_bullets):
		var fraction = float(i) / float(number_of_bullets - 1) 
		var difference = max_rotation - min_rotation
		rotations.append((fraction * difference) + min_rotation)

func spawn_bullets():
	if is_random:
		random_rotations()
	else:
		distributed_rotations()
	
	var spawned_bullets = [];
	for i in range(0, number_of_bullets):
		# Instancing
		var bullet = bullet_scene.instance()
		
		spawned_bullets.append(bullet)
		
		get_parent().get_node("../Bullets").add_child(spawned_bullets[i])
			
		# Apply Fields
		spawned_bullets[i].position = position
		spawned_bullets[i].rotation_degrees = rotations[i] + rotation_degrees
		spawned_bullets[i].dir = dir
		spawned_bullets[i].speed = bullet_speed
		spawned_bullets[i].can_be_destroyed = true
		
		if (log_to_console):
			print("Bullet " + str(i) + " @ " + str(rotations[i]) + "deg")
	
	if oddness:
			odd = !odd
			if odd:
				number_of_bullets -= 1
			else:
				number_of_bullets += 1
	
	return spawned_bullets

func _on_Timer_timeout():
	if can_shoot:
		spawn_bullets()

func burst_timeout():
	can_shoot = !can_shoot
	if can_shoot:
		burst_instance.start(5)
	else:
		burst_instance.start(1)

func hitbox_activated(area):
	hit_variant = randi()%2
	match hit_variant:
		0:
			hit_sfx.stream = var1
		1:
			hit_sfx.stream = var2
	hit_sfx.play()
	blink_animation.play("blink")
	stats.health -= area.damage

func no_health():
	blink_animation.play("stop")
	PlayerStats.score += 100
	queue_free()

func blink_finished(_anim_name):
	blink_animation.play("stop")

extends Node2D

export var bullet_scene: PackedScene
export var min_rotation = 0
export var max_rotation = 180
export var number_of_bullets = 15
export var is_random = false
export var is_parent = false
export var is_manual = false
export var spawn_rate = 0.8
export var bullet_speed = 0.8
export var dir = Vector2(1,0)
export var log_to_console = false
export var oddness = true
export var spin = 0.0
export var var1: AudioStream
export var var2: AudioStream
export var madman = false

onready var player = get_parent().get_parent().get_node("Player")
onready var stats = $Stats
onready var timer = $Timer
onready var tween = $Tween
onready var blink_animation = $BlinkAnimation
onready var hit_sfx = $HitSfx

var rotations = []
var odd = false
var hit_variant

func _process(delta):
	rotate(spin * delta)
	pass

func _ready():
	timer.wait_time = spawn_rate
	timer.start()
	tween.interpolate_property(self, "position", Vector2(250, -25), Vector2(250, 25), 5, Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	if madman:
		$Sprite.modulate = Color("f31919")

func distributed_rotations():
	rotations = []
	for i in range(0, number_of_bullets):
		var fraction = float(i) / float(number_of_bullets - 1) 
		var difference = max_rotation - min_rotation
		rotations.append((fraction * difference) + min_rotation)

func spawn_bullets():
	
	if stats.health <= stats.max_health / 2:
		if !madman:
			oddness = true
			min_rotation = 0
			max_rotation = 360
			spawn_rate = 0.7
			bullet_speed = 0.3
			spin = 0.5
			number_of_bullets = 13
		else:
			oddness = true
			min_rotation = 0
			max_rotation = 360
			spawn_rate = 0.7
			bullet_speed = 0.3
			spin = 0.3
			number_of_bullets = 4
		
	
	distributed_rotations()
	
	var spawned_bullets = [];
	for i in range(0, number_of_bullets):
		# Instancing
		var bullet = bullet_scene.instance()
		
		spawned_bullets.append(bullet)
		
		# Parenting
		if (is_parent):
			add_child(spawned_bullets[i])
		else:
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
				bullet_speed += 0.1  
			else: 
				number_of_bullets += 1
				bullet_speed -= 0.1  
	
	return spawned_bullets

func _on_Timer_timeout():
	spawn_bullets()

var h = true

func hitbox_activated(area):
	hit_variant = randi()%2
	match hit_variant:
		0:
			hit_sfx.stream = var1
		1:
			hit_sfx.stream = var2
	hit_sfx.play()
	blink_animation.play("blink")
	if stats.health <= stats.max_health / 2:
		stats.health -= area.damage * 0.5
	else:
		stats.health -= area.damage
	if stats.health <= stats.max_health / 2 and h:
		tween.interpolate_property(self, "position", Vector2(250, 25), Vector2(250, 75), 5, Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween.start()
		h = false

func no_health():
	$Area2D/Shockwave.visible = true
	$Area2D/CollisionShape2D.set_deferred("disabled",false)
	$AnimationPlayer.play("Shockwave")
	$Timer.stop()
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$Sprite.visible = false
	PlayerStats.score += 2000
	PlayerStats.time += 10
	PlayerStats.boss_beat = true
	$DeathTimer.start()

func blink_finished(_anim_name):
	blink_animation.play("stop")

func death_finished():
	GameMachine.change_level()

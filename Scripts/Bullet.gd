extends Node2D

onready var sprite = $Sprite
onready var area = $Area2D
onready var stats = $Stats
onready var blink_animation = $BlinkAnimation
onready var hit_sfx = $HitSfx
var can_be_destroyed = false
var hit_variant
var rotations = []
export var dir = Vector2(0,1)
export var speed = 1.0
export var spin = 0.0
export var bullet = true
export var damage = 1
export var donut = false
export var var1: AudioStreamMP3
export var var2: AudioStreamMP3
export var bullet_scene : Resource
export var time: int = 0

func _ready():
	blink_animation.connect("animation_finished", self, "blink_finished")

func _process(delta):
	self.position += dir.rotated(self.rotation) * delta * 100 * speed
	sprite.rotate(spin)
	area.rotate(spin)
	area.damage = self.damage

func screen_exited():
	if can_be_destroyed:
		queue_free()

func collided(_area):
	stats.health -= area.damage
	if can_be_destroyed and bullet:
		queue_free()
	else:
		hit_variant = randi()%2
		match hit_variant:
			0:
				hit_sfx.stream = var1
			1:
				hit_sfx.stream = var2
		hit_sfx.play()
		blink_animation.play("blink")

func delay_to_destroy():
	can_be_destroyed = true

func no_health():
	PlayerStats.time += time
	if donut:
		PlayerStats.health += 2
		PlayerStats.score += 1000
	queue_free()

func blink_finished(_anim_name):
	blink_animation.play("stop")

func explode():
	spawn_bullets()
	queue_free()

func distributed_rotations():
	rotations = []
	for i in range(0, 7):
		var fraction = float(i) / float(7 - 1) 
		var difference = 360
		rotations.append(fraction * difference)

func spawn_bullets():
	distributed_rotations()
	
	var spawned_bullets = [];
	for i in range(0, 7):
		# Instancing
		var bullett = bullet_scene.instance()
		
		spawned_bullets.append(bullett)
		
		get_parent().get_node("../Bullets").add_child(spawned_bullets[i])
			
		# Apply Fields
		spawned_bullets[i].position = position
		spawned_bullets[i].rotation_degrees = rotations[i] + rotation_degrees
		spawned_bullets[i].dir = dir
		spawned_bullets[i].speed = 1
		spawned_bullets[i].can_be_destroyed = true
	
	
	return spawned_bullets


# warning-ignore:shadowed_variable
func shockwave(area):
	if area.is_in_group("Shockwave"):
		queue_free()

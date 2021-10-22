extends Node2D

export var bullet : Resource = load("res://Scenes/Objects/Enemy Bullet.tscn")
export var enemy_type : int = 1
var hit_variant
export var var1: AudioStream
export var var2: AudioStream
onready var player = get_parent().get_parent().get_node("Player")
onready var stats = $Stats
onready var blink_animation = $BlinkAnimation
onready var hit_sfx = $HitSfx
	
# warning-ignore:unused_argument
func _process(delta):
	#rotate(.7 * delta)
	rotate(PI/2 + get_angle_to(player.position))
	pass
	
func bullet_delay():
	spawn_bullets()
	
func spawn_bullets():
	match enemy_type:
		1:
			var b1 = bullet.instance()
			b1.position = $Guns/Gun1.get_global_transform().get_origin()
			b1.rotation = self.rotation
			b1.dir = Vector2(0,-1)
			b1.speed = 1.5
			b1.can_be_destroyed = true
			
			var b2 = bullet.instance()
			b2.position = $Guns/Gun2.get_global_transform().get_origin()
			b2.rotation = self.rotation
			b2.dir = Vector2(0,-1)
			b2.speed = 1.5
			b2.can_be_destroyed = true
			
			get_parent().add_child(b1)
			get_parent().add_child(b2)
		2:
			var b1 = bullet.instance()
			b1.position = $Guns/Gun1.get_global_transform().get_origin()
			b1.rotation = self.rotation
			b1.dir = Vector2(0,-1)
			b1.speed = 1
			b1.can_be_destroyed = true
			
			get_parent().add_child(b1)
		3:
			var b1 = bullet.instance()
			b1.position = $Guns/Gun1.get_global_transform().get_origin()
			b1.rotation = self.rotation
			b1.dir = Vector2(-0.2,-1)
			b1.speed = 1.5
			b1.can_be_destroyed = true
			
			var b2 = bullet.instance()
			b2.position = $Guns/Gun2.get_global_transform().get_origin()
			b2.rotation = self.rotation
			b2.dir = Vector2(0.2,-1)
			b2.speed = 1.5
			b2.can_be_destroyed = true
			
			var b3 = bullet.instance()
			b3.position = $Guns/Gun3.get_global_transform().get_origin()
			b3.rotation = self.rotation
			b3.dir = Vector2(0,-1)
			b3.speed = 1.5
			b3.can_be_destroyed = true
			
			get_parent().add_child(b1)
			get_parent().add_child(b2)
			get_parent().add_child(b3)
		4:
			var b1 = bullet.instance()
			b1.position = $Guns/Gun1.get_global_transform().get_origin()
			b1.rotation = self.rotation
			b1.dir = Vector2(0.05,-1)
			b1.speed = 2
			b1.can_be_destroyed = true
			
			var b2 = bullet.instance()
			b2.position = $Guns/Gun2.get_global_transform().get_origin()
			b2.rotation = self.rotation
			b2.dir = Vector2(-0.05,-1)
			b2.speed = 2
			b2.can_be_destroyed = true
			
			get_parent().add_child(b1)
			get_parent().add_child(b2)
	

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

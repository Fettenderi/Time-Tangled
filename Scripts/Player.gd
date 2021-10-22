extends Node2D

var bullet = load("res://Scenes/Objects/Player Bullet.tscn")
var hit1 = load("res://Sfx/sfx_zapsplat_metal_hit1.wav")
var hit2 = load("res://Sfx/sfx_zapsplat_metal_hit2.wav")
onready var gun1 = $Guns/Gun1
onready var gun2 = $Guns/Gun2
onready var gun3 = $Guns/Gun3
onready var shoot_delay = $Timer
onready var shoot_sfx = $ShootSfx
onready var hit_sfx = $HitSfx
onready var clock_tick = $ClockTick
onready var animation_tree = $AnimationTree
onready var blink_animation = $BlinkAnimation
onready var animation_state = animation_tree.get("parameters/playback")
var s_delay = 0.3
var can_shoot_v = true
var hit_variant = 1
var bullet_damage = 1
var shield_on = false

func _ready():
	if PlayerStats.high_score >= 50000:
		$Sprite.texture = load("res://Sprites/PlayerMadman.png")
	
	position = PlayerStats.spawn_position
	bullet_damage = PlayerStats.damage
	s_delay = PlayerStats.fire_rate
# warning-ignore:return_value_discarded
	PlayerStats.connect("no_health",self,"no_health")
# warning-ignore:return_value_discarded
	PlayerStats.connect("no_shield",self,"no_shield")
# warning-ignore:return_value_discarded
	PlayerStats.connect("fire_rate_changed",self,"change_fire_rate")
# warning-ignore:return_value_discarded
	PlayerStats.connect("damage_changed",self,"change_damage")
# warning-ignore:return_value_discarded
	PlayerStats.connect("time_changed",self,"tick")
	animation_tree.active = true
# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

func _process(delta):
	move(delta)
	aim()
	if PlayerStats.score >= 50000:
		$Sprite.texture = load("res://Sprites/PlayerMadman.png")

func move(delta):
	position.x += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * delta * 125 #155 controller perfection
	position.y += (Input.get_action_strength("move_up") - Input.get_action_strength("move_down")) * delta * 125 #125 keyboard perfection
	position.x = clamp(position.x,0,512)
	position.y = clamp(position.y,0,300)
	PlayerStats.set_deferred("spawn_position",position)

func aim():
	var input_vector = Vector2.UP
	input_vector.x = (Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"))
	input_vector.y = (Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
	input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position",input_vector)
		animation_tree.set("parameters/Shoot/blend_position",input_vector)
		animation_state.travel("Shoot")
		if can_shoot_v:
			spawn_bullets()
			can_shoot_v = false
			shoot_delay.start(s_delay)
	else:
		animation_state.travel("Idle")

func spawn_bullets():
	#GameMachine.camera.shake_start(10,0.1)
	match PlayerStats.shoot_type:
		1:
			shoot_sfx.play()
			var b1 = bullet.instance()
			b1.position = gun3.get_global_transform().get_origin()
			b1.rotation = self.rotation
			b1.dir = Vector2(0, -1)
			b1.can_be_destroyed = true
			b1.damage = bullet_damage + 2
			b1.scale = Vector2(1.5,1.5)
			
			get_parent().add_child(b1)
		2:
			shoot_sfx.play()
			var b1 = bullet.instance()
			b1.position = gun1.get_global_transform().get_origin()
			b1.rotation = self.rotation
			b1.dir = Vector2(0, -1)
			b1.can_be_destroyed = true
			b1.damage = bullet_damage
			
			var b2 = bullet.instance()
			b2.position = gun2.get_global_transform().get_origin()
			b2.rotation = self.rotation
			b2.dir = Vector2(0, -1)
			b2.can_be_destroyed = true
			b2.damage = bullet_damage
			
			get_parent().add_child(b1)
			get_parent().add_child(b2)
		3:
			shoot_sfx.play()
			var b1 = bullet.instance()
			b1.position = gun1.get_global_transform().get_origin()
			b1.rotation = self.rotation
			b1.dir = Vector2(-0.2, -1)
			b1.can_be_destroyed = true
			b1.damage = bullet_damage + 0.3
			b1.scale = Vector2(1.3,1.3)
			
			var b2 = bullet.instance()
			b2.position = gun2.get_global_transform().get_origin()
			b2.rotation = self.rotation
			b2.dir = Vector2(0.2, -1)
			b2.can_be_destroyed = true
			b2.damage = bullet_damage + 0.5
			b2.scale = Vector2(1.3,1.3)
			
			var b3 = bullet.instance()
			b3.position = gun3.get_global_transform().get_origin()
			b3.rotation = self.rotation
			b3.dir = Vector2(0, -1)
			b3.can_be_destroyed = true
			b3.damage = bullet_damage + 0.3
			b3.scale = Vector2(1.3,1.3)
			
			
			get_parent().add_child(b1)
			get_parent().add_child(b2)
			get_parent().add_child(b3)

func hitbox_activated(area):
	if area.damage != 0:
		if !shield_on:
			blink_animation.play("blink")
			PlayerStats.health -= area.damage
		else:
			blink_animation.play("shield")
		#GameMachine.camera.shake_start(200)
		hit_variant = randi()%2
		match hit_variant:
			0:
				hit_sfx.stream = hit1
			1:
				hit_sfx.stream = hit2
		hit_sfx.play()

func can_shoot():
	can_shoot_v = true

func one_second():
	PlayerStats.time -= 1

func shield_one_second():
	shield_on = true
	PlayerStats.shield_time -= 1

func no_health():
	PlayerStats.spawn_position = Vector2(250,270)
	GameMachine.set_deferred("level","res://Scenes/Levels/Level1.tscn")
	Input.action_press("reset")
	
func no_shield():
	shield_on = false

func change_fire_rate(value):
	s_delay = value

func change_damage(value):
	bullet_damage = value

func blink_finished(_anim_name):
	blink_animation.play("stop")

func tick(value):
	if value <= 20:
		clock_tick.volume_db = - 3 * value + 3
	else:
		clock_tick.volume_db = - 80
	pass

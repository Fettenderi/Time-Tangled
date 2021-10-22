extends Node

var max_health = 8 setget set_max_health
var health = max_health setget set_health
var fire_rate = 0.3 setget set_fire_rate # 0.3
var damage = 1 setget set_damage
var time = 10 setget set_time
var shield_time = 5 setget set_shield_time
var score = 0 setget set_score
var high_score = 0 setget set_high_score
var shoot_type = 2
var spawn_position = Vector2(250,270)
var boss_beat = false
var language = "en"

var cardinality = "Left" setget set_cardinality

signal no_health
signal no_shield
signal health_changed(value)
signal max_health_changed(value)
signal fire_rate_changed(value)
signal damage_changed(value)
signal time_changed(value)
signal shield_time_changed(value)
signal score_changed(value)
signal high_score_changed(value)

signal cardinality_changed(value)

func set_score(value):
	score = value
	emit_signal("score_changed",score)

func set_high_score(value):
	high_score = value
	emit_signal("high_score_changed",high_score)

func set_health(value):
	health = clamp(value,0,8)
	emit_signal("health_changed",health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	self.health = min(health,max_health)
	emit_signal("max_health_changed",max_health)

func set_time(value):
	time = value
	emit_signal("time_changed",time)
	if time <= 0:
		emit_signal("no_health")
	elif time >= 100:
		time = 100

func set_shield_time(value):
	shield_time = value
	emit_signal("shield_time_changed",shield_time)
	if shield_time <= 0:
		emit_signal("no_shield")

func set_fire_rate(value):
	fire_rate = clamp(value,0.09,0.3)
	emit_signal("fire_rate_changed",fire_rate)

func set_damage(value):
	damage = value
	emit_signal("damage_changed",damage)

func set_cardinality(value):
	cardinality = value
	emit_signal("cardinality_changed",cardinality)

var save_filename = "user://save_game.save"

func save_game():
	var save_file = File.new()
	save_file.open(save_filename,File.WRITE)
	
	save_file.store_line(to_json({
		'high_score':high_score,
		'boss_beat':boss_beat,
		'language':language,
		'fullscreen':OS.window_fullscreen,
		'music':AudioServer.is_bus_mute(1),
		'sfx':AudioServer.is_bus_mute(2)
	}))
	
	save_file.close()

func load_game():
	var save_file = File.new()
	if !save_file.file_exists(save_filename):
		return
	
	save_file.open(save_filename,File.READ)
	
	while save_file.get_position() < save_file.get_len():
		var content = parse_json(save_file.get_line())
		high_score = content.high_score
		boss_beat = content.boss_beat
		language = content.language
		OS.window_fullscreen = content.fullscreen
		AudioServer.set_bus_mute(1, content.music)
		AudioServer.set_bus_mute(2, content.sfx)
	
	save_file.close()
	
	

extends Node2D

enum {
	MAIN,
	CREDITS,
	PAUSE,
	PLAYING,
	RESTART,
	WAIT
}

export var level_offset : int
export var enemies : Array
export var buffs : Array = [
	"res://Scenes/Objects/Full Health.tscn",
	"res://Scenes/Objects/Full Health.tscn",
	"res://Scenes/Objects/Full Health.tscn",
	"res://Scenes/Objects/Full Health.tscn",
	"res://Scenes/Objects/Stopwatch.tscn",
	"res://Scenes/Objects/Stopwatch.tscn",
	"res://Scenes/Objects/Stopwatch.tscn",
	"res://Scenes/Objects/Stopwatch.tscn",
	"res://Scenes/Objects/Stopwatch.tscn",
	"res://Scenes/Objects/Shield.tscn",
	"res://Scenes/Objects/Shield.tscn",
	"res://Scenes/Objects/Shield.tscn",
	"res://Scenes/Objects/Damage Up.tscn",
	"res://Scenes/Objects/Damage Up.tscn",
	"res://Scenes/Objects/Damage Up.tscn",
	"res://Scenes/Objects/Single Shoot.tscn",
	"res://Scenes/Objects/Double Shoot.tscn",
	"res://Scenes/Objects/Double Shoot.tscn",
	"res://Scenes/Objects/Triple Shoot.tscn",
	"res://Scenes/Objects/Triple Shoot.tscn"
	]
export var boss_id : String

var relative_score = 0
var go = true

func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("score_changed",self,"set_relative_score")
	spawn_enemies(1)
	spawn_buff()

func _process(_delta):
	if $Enemies.get_child_count() == 0 and go == true and GameMachine.page == PLAYING:
		$Spawn.start()
		go = false

func set_relative_score(score):
	relative_score = clamp(score - 10000 * level_offset,0,100000)

func spawn_enemies(number_of_enemies):
#	randomize()
	var enemy
	var boss
	
	if relative_score >= 10000:
		if level_offset == 4:
			pass
		else:
			GameMachine.set_deferred("level","res://Scenes/Levels/Level" + str(level_offset + 2) + ".tscn")
		number_of_enemies = 0
		boss = load(boss_id).instance()
		
		get_node("Enemies").add_child(boss)
	
	for _i in range(0, number_of_enemies):
		var enemy_id = choose(enemies)
		var spawn_position = Vector2(rand_range(50,462),rand_range(100,200))
		var player_position = $Player.position
		
		if abs(spawn_position.x - player_position.x) < 40 and abs(spawn_position.y - player_position.y) < 40:
			spawn_position.x = spawn_position.x + sign(spawn_position.x - player_position.x) * 20
			spawn_position.y = spawn_position.y + sign(spawn_position.y - player_position.y) * 20
		
		
		enemy = load(enemy_id).instance()
		
		get_node("Enemies").add_child(enemy)
		enemy.global_position = spawn_position

func spawn_buff():
	var buff
	buff = load(choose(buffs)).instance()
	
	get_node("Objects").add_child(buff)
	buff.global_position = Vector2(rand_range(30,482),rand_range(30,270))

func spawn():
	randomize()
	var noe = randi() % (PlayerStats.score/10000 + 1) + 1
	spawn_enemies(noe)
	spawn_buff()
	if PlayerStats.time <= 50:
		PlayerStats.time += 5
		$Spawn.wait_time = 0.5
	else:
		$Spawn.wait_time = 1
	go = true

func choose(things : Array):
	randomize()
	things.shuffle()
	return things.front()

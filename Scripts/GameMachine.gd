extends Node

enum {
	MAIN,
	CREDITS,
	PAUSE,
	PLAYING,
	RESTART
}

var camera = null
export var level : String = "res://Scenes/Levels/Level1.tscn"
var page = MAIN

func _ready():
	PlayerStats.load_game()
	TranslationServer.set_locale(PlayerStats.language)
	get_parent().get_node("Blank").queue_free()
# warning-ignore:unused_argument
func _process(delta):
	match page:
		MAIN:
			pass
		RESTART:
			reset_stats()
			page = PLAYING

func reset_stats():
	PlayerStats.time = 10
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.damage = 1
	PlayerStats.fire_rate = 0.3
	PlayerStats.shield_time = 0
	if PlayerStats.score > PlayerStats.high_score:
		PlayerStats.high_score = PlayerStats.score + PlayerStats.time
	PlayerStats.score = 0
	PlayerStats.shoot_type = 2
	PlayerStats.save_game()

func set_pause_node(node : Node, pause : bool) -> void:
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)

func set_pause_scene(rootNode : Node, pause : bool, ignoredChilds : PoolStringArray = [null]):
	set_pause_node(rootNode, pause)
	for node in rootNode.get_children():
		if not (String(node.get_path()) in ignoredChilds):
			set_pause_scene(node, pause, ignoredChilds)

func change_level():
	get_level().queue_free()
	add_child(load(level).instance())

func get_level():
	var children = get_child_count()
	
	for i in children:
		if get_child(i).to_string().begins_with("[Node2D:"):
			return get_child(i)

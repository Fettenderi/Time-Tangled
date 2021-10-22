extends Node2D

enum {
	MAIN,
	CREDITS,
	PAUSE,
	PLAYING,
	RESTART,
	WAIT
}

var enemy
var i = 0
var time_on = false

# warning-ignore:unused_argument
func _process(delta):
	if !time_on:
		PlayerStats.time = 10
	if Input.is_action_just_pressed("reset"):
		GameMachine.level = "res://Scenes/Levels/Level1.tscn"
		PlayerStats.health = 0

func one_sec():
	match i:
		8:
			$Control.visible = false
			time_on = true
		20:
			GameMachine.level = "res://Scenes/Levels/Level1.tscn"
	i += 1

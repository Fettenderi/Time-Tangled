extends Control

enum {
	MAIN,
	CREDITS,
	PAUSE,
	PLAYING,
	RESTART
}

var menu_music = load("res://Sfx/ost_ecrettmusic_main.ogg")

onready var main = $Main
onready var credits = $Credits
onready var audioStreamPlayer = $Main/AudioStreamPlayer

func _ready():
	$Main/VBoxContainer/PlayButton.grab_focus()

func _process(_delta):
	if PlayerStats.high_score >= 50000:
		$Madman.visible = true
	if PlayerStats.boss_beat:
		$FirstBoss.visible = true
	match GameMachine.page:
		MAIN:
			if Input.is_action_just_pressed("esc"):
				PlayerStats.save_game()
				get_tree().quit()
		CREDITS:
			if Input.is_action_just_pressed("esc"):
				back()

func play():
	audioStreamPlayer.play()
	PlayerStats.high_score = PlayerStats.high_score
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
# warning-ignore:return_value_discarded
	get_parent().add_child(load(GameMachine.level).instance())
	get_parent().add_child(load("res://Scenes/Levels/Pause Menu.tscn").instance())
	queue_free()
	GameMachine.reset_stats()
	GameMachine.get_node("CanvasLayer").layer = 1
	GameMachine.page = PLAYING

# warning-ignore:function_conflicts_variable
func credits():
	audioStreamPlayer.play()
	main.visible = false
	credits.visible = true
	$Credits/BackButton.grab_focus()
	GameMachine.page = CREDITS

func back():
	audioStreamPlayer.play()
	main.visible = true
	credits.visible = false
	$Main/VBoxContainer/PlayButton.grab_focus()
	GameMachine.page = MAIN

func close():
	PlayerStats.save_game()
	get_tree().quit()

# warning-ignore:unused_argument
func music_toggle(toggle):
	audioStreamPlayer.play()
	AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))

# warning-ignore:unused_argument
func sfx_toggle(toggle):
	audioStreamPlayer.play()
	AudioServer.set_bus_mute(2, not AudioServer.is_bus_mute(2))

# warning-ignore:unused_argument
func fullscreen_toggle(button_pressed):
	audioStreamPlayer.play()
	OS.set_window_fullscreen(!OS.is_window_fullscreen())

func tutorial():
	audioStreamPlayer.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
# warning-ignore:return_value_discarded
	get_parent().add_child(load("res://Scenes/Levels/Tutorial.tscn").instance())
	get_parent().add_child(load("res://Scenes/Levels/Pause Menu.tscn").instance())
	queue_free()
	GameMachine.get_node("CanvasLayer").layer = 1
	GameMachine.page = PLAYING

func italian_pressed():
	audioStreamPlayer.play()
	PlayerStats.language = "it"
	TranslationServer.set_locale(PlayerStats.language)

func english_pressed():
	audioStreamPlayer.play()
	PlayerStats.language = "en"
	TranslationServer.set_locale(PlayerStats.language)

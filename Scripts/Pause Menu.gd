extends CanvasLayer

enum {
	MAIN,
	CREDITS,
	PAUSE,
	PLAYING,
	RESTART,
	WAIT
}

var menu_music = load("res://Sfx/ost_ecrettmusic_main.ogg")

onready var pause = $Pause
onready var unpause = $Unpause
onready var back = $Back
onready var audioStreamPlayer = $Pause/AudioStreamPlayer
onready var timer = $Timer

func _process(_delta):
	match GameMachine.page:
		PAUSE:
			if Input.is_action_just_pressed("pause"):
				continuee()
		PLAYING:
			if Input.is_action_just_pressed("reset"):
				audioStreamPlayer.play()
				# warning-ignore:return_value_discarded
				GameMachine.get_level().queue_free()
				get_parent().add_child(load(GameMachine.level).instance(),true)
				GameMachine.page = RESTART
				
			if Input.is_action_just_pressed("pause"):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				GameMachine.set_pause_scene(GameMachine.get_level(),true)
				Input.warp_mouse_position(OS.get_window_size()/2)
				get_parent().get_node("CanvasLayer").layer = -1
				back.visible = true
				pause.visible = true
				unpause.visible = false
				$Pause/VBoxContainer/ContinueButton.grab_focus()
				GameMachine.page = PAUSE
				

func continuee():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pause.visible = false
	unpause.visible = true
	$AnimationPlayer.play("Unpause")
	audioStreamPlayer.play()
	GameMachine.page = WAIT
	timer.start(3)

# warning-ignore:function_conflicts_variable
func back():
	get_tree().paused = false
	audioStreamPlayer.play()
	# warning-ignore:return_value_discarded
	get_parent().add_child(load("res://Scenes/Levels/Main Menu.tscn").instance())
	GameMachine.get_level().queue_free()
	queue_free()
	GameMachine.page = MAIN

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
	OS.set_window_fullscreen(!OS.is_window_fullscreen())

func start():
	GameMachine.set_pause_scene(GameMachine.get_level(),false)
	get_parent().get_node("CanvasLayer").layer = 1
	back.visible = false
	pause.visible = false
	unpause.visible = false
	GameMachine.page = PLAYING



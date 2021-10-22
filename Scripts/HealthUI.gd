extends Control

var hearts = 8 setget set_hearts
var max_hearts = 8 setget set_max_hearts
var time = 10 setget set_time
var shield_time = 5 setget set_shield_time

onready var time_label = $Timer
onready var shield_label = $Shield
onready var health_ui = $AnimatedSprite
onready var score = $VBoxContainer/Score
onready var high_score = $VBoxContainer/HighScore
onready var madman = $MadmanEnding

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	self.time = PlayerStats.time
	self.shield_label.visible = false
# warning-ignore:return_value_discarded
	PlayerStats.connect("score_changed",self,"set_score")
# warning-ignore:return_value_discarded
	PlayerStats.connect("high_score_changed",self,"set_high_score")
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed",self,"set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed",self,"set_max_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("time_changed",self,"set_time")
# warning-ignore:return_value_discarded
	PlayerStats.connect("shield_time_changed",self,"set_shield_time")
# warning-ignore:return_value_discarded
	PlayerStats.connect("no_shield",self,"no_shield")
# warning-ignore:return_value_discarded
	PlayerStats.connect("cardinality_changed",self,"change_cardinality")


func set_score(value):
	score.text = tr("score_lbl") + ": " + String(value)
	if value >= 50000:
		madman.visible = true

func set_high_score(value):
	high_score.text = tr("high_score_lbl") + ": " + String(value)

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	health_ui.frame = value

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts,max_hearts)

func set_time(value):
	time_label.text = String(value)

# warning-ignore:unused_argument
func set_shield_time(value):
	shield_label.visible = true

func no_shield():
	shield_label.visible = false

func change_cardinality(_value):
	pass

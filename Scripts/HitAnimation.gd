extends Node2D

onready var sprite1 = $Sprite
onready var sprite2 = $Sprite2
onready var sprite3 = $Sprite3

onready var animation = $AnimationPlayer

export var sprite: Texture

signal animation_finished

func _ready():
	rotation = rand_range(0, 2 * PI)
	sprite1.texture = sprite
	sprite2.texture = sprite
	sprite3.texture = sprite

func start_animation():
	animation.play("hit_animation")

func animation_finished(_anim_name):
	emit_signal("animation_finished")
	rotation = rand_range(0, 2 * PI)

extends TextureRect

var possible_wallpapers : Array

func _ready() -> void:
	for i in range(1,6):
		possible_wallpapers.append(load("res://Sprites/Backgrounds/Space Background (" + str(i) + ").png"))
	texture = choose(possible_wallpapers)

func choose(array : Array):
	randomize()
	array.shuffle()
	return array.front()

extends Node2D

export var type = ""

# warning-ignore:unused_argument
func interacted(area):
	match type:
		"Stopwatch":
			PlayerStats.time += 10
			PlayerStats.score += 100
		"Shield":
			PlayerStats.shield_time = 5
			PlayerStats.score += 200
		"FullHealth":
			PlayerStats.health = PlayerStats.max_health
			PlayerStats.score += 200
		"DamageUp":
			PlayerStats.damage += 0.5
			PlayerStats.score += 500
		"SingleShoot":
			PlayerStats.fire_rate += 0.03
			PlayerStats.damage += 0.2
			PlayerStats.shoot_type = 1
			PlayerStats.score += 300
		"DoubleShoot":
			PlayerStats.fire_rate -= 0.03
			PlayerStats.shoot_type = 2
			PlayerStats.score += 300
		"TripleShoot":
			PlayerStats.fire_rate -= 0.02
			PlayerStats.shoot_type = 3
			PlayerStats.score += 300
	$AudioStreamPlayer.play()
	queue_free()

# warning-ignore:unused_argument
func restart_anim(anim_name):
	$AnimationPlayer.play("Idle")

func shockwave(area):
	if area.is_in_group("Shockwave"):
		queue_free()

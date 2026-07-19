extends Node2D

@export var start_pos: Array[Marker2D]
@export var end_pos: Array[Marker2D]
var count: int = 0

func _ready() -> void:
	global_position = Vector2.ZERO
	var cage = Global.battle.soul_cage.panel
	$Cage.size = cage.size-(Vector2.ONE*12.0)
	$Cage.global_position = cage.global_position+(Vector2.ONE*6.0)
	

func _on_timer_timeout() -> void:
	count += 1
	if count >= 7:
		return
	var rand_start_pos = start_pos.duplicate()
	rand_start_pos.shuffle()
	var bullet = preload("uid://ds6qyt7d0yshl").instantiate()
	bullet.start_pos = rand_start_pos.pop_front()
	bullet.end_pos = end_pos.pick_random()
	$Cage.add_child(bullet)
	var bullet2 = preload("uid://ds6qyt7d0yshl").instantiate()
	bullet2.start_pos = rand_start_pos.pick_random()
	bullet2.end_pos = end_pos.pick_random()
	$Cage.add_child(bullet2)
	

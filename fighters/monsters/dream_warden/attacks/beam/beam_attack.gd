extends Node2D

@export var start_pos: Array[Marker2D]
@export var end_pos: Array[Marker2D]

func _ready() -> void:
	global_position = Vector2.ZERO
	var cage = Global.battle.soul_cage.panel
	$Cage.size = cage.size-(Vector2.ONE*12.0)
	$Cage.global_position = cage.global_position+(Vector2.ONE*6.0)

func _on_timer_timeout() -> void:
	var bullet = preload("uid://ds6qyt7d0yshl").instantiate()
	bullet.start_pos = start_pos.pick_random().global_position
	bullet.end_pos = end_pos.pick_random().global_position
	$Cage.add_child(bullet)
	

extends Node2D

@export var spawnpoints: Array[Marker2D]
var current_side = 0


func _on_timer_timeout() -> void:
	
	$SideSwapper.scale.x = [-1.0,1.0].pick_random()
	var spawnpoint = spawnpoints[current_side]
	current_side = wrapi(current_side+1,0,2)
	$PelletSpawner.spawn(spawnpoint.global_position)
	

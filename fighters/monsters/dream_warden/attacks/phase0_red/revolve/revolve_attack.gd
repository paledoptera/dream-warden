extends Node2D

@export var spawnpoints: Array[Node2D]
@export var spinner: Node2D
@onready var last: Node = $SpinnerContainer/Start
var current: Node

func _process(delta: float) -> void:
	spinner.rotate(2 * delta)
	
	if last and current:
		$Lightning.global_position = Vector2.ZERO
		$Lightning.set_point_position(0,last.global_position)
		$Lightning.set_point_position(1,current.global_position)

func _on_timer_timeout() -> void:
	if current:
		last = current
	
	var valid_spawnpoints = spawnpoints.duplicate()
	
	if last:
		valid_spawnpoints.erase(last)
	
	
	var spawnpoint = valid_spawnpoints.pick_random()
	current = spawnpoint
	
	$AnimationPlayer.play("shock")
	await $AnimationPlayer.animation_finished
	$PelletSpawnerMega.spawn(spawnpoint.global_position)
	$PelletSpawner.spawn(spawnpoint.global_position)

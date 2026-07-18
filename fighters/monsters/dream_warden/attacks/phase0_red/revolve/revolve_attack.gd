extends Node2D

@export var spawnpoints: Array[Node2D]
@export var spinner: Node2D
@onready var last: Node = $SpinnerContainer/Start
var current: Node

func _enter_tree() -> void:
	Global.battle.bottom_panel.slide_down()
	Global.battle.move_camera(Vector2(0.0,-100.0),1.0,Tween.EaseType.EASE_OUT)
	Global.battle.move_soul_cage(Vector2(0.0,25.0),1.0,false,Tween.EaseType.EASE_OUT)

func _exit_tree() -> void:
	Global.battle.bottom_panel.slide_up()
	Global.battle.move_camera(Vector2(0.0,0.0),1.0,Tween.EaseType.EASE_OUT)
	Global.battle.move_soul_cage(Vector2(0.0,-25.0),1.0,false,Tween.EaseType.EASE_OUT)

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

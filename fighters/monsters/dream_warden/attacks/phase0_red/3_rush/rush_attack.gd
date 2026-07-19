extends Node2D

@export var spawnpoints: Array[Marker2D]
var order = []
var ind = 0
var current_side = 0

func _ready() -> void:
	await get_tree().create_timer(0.77).timeout
	
	_on_timer_timeout()
	$Timer.start()

func _process(delta: float) -> void:
	
	$Attack.global_position.x = Global.soul.global_position.x


func _on_timer_timeout() -> void:
	
	var sparkle = preload("uid://cbu3432aw4rry").instantiate()
	$Attack.add_child(sparkle)
	
	var side = [-1.0,1.0].pick_random()
	order.append(side)
	sparkle.scale.x = side
	var sparkle_sprite = sparkle.get_node("AnimatedSprite2D")
	sparkle_sprite.play("sparkle")
	sparkle_sprite.animation_finished.connect(sparkle_sprite.queue_free)
	
	Sounds.play("snd_eye_telegraph",1.0,1.0,5)
	
	if order.size() >= 3:
		$Timer.stop()
	else:
		return
	
	$AnimationPlayer.play("back_off")
	await get_tree().create_timer(1.4).timeout
	
	_on_rush_timer_timeout()
	$RushTimer.start()



func _on_rush_timer_timeout() -> void:
	$Attack/SideSwapper.scale.x = order[ind]
	
	var bullet = $Attack/SideSwapper/Side/PelletSpawner.spawn(Vector2(-1,-1),$Attack)
	bullet.scale.x = order[ind]
	bullet.position.x = $Attack/SideSwapper/Side.position.x * bullet.scale.x
	ind += 1
	if ind >= order.size():
		$RushTimer.stop()
	await get_tree().create_timer(0.5).timeout
	Sounds.play("snd_knight_cut2",1.0,1.0,5)

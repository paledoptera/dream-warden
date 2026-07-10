extends Node2D

@export var spawnpoints: Array[Marker2D]
var order = []
var ind = 0
var current_side = 0

func _ready() -> void:
	await get_tree().create_timer(0.77).timeout
	
	_on_timer_timeout()
	$Timer.start()


func _on_timer_timeout() -> void:
	
	var sparkle = preload("uid://cbu3432aw4rry").instantiate()
	add_child(sparkle)
	
	var side = [-1.0,1.0].pick_random()
	order.append(side)
	sparkle.scale.x = side
	var sparkle_sprite = sparkle.get_node("AnimatedSprite2D")
	sparkle_sprite.play("sparkle")
	sparkle_sprite.animation_finished.connect(sparkle_sprite.queue_free)
	
	if order.size() >= 5:
		$Timer.stop()
	else:
		return
	
	$AnimationPlayer.play("back_off")
	await get_tree().create_timer(1.4).timeout
	
	_on_rush_timer_timeout()
	$RushTimer.start()



func _on_rush_timer_timeout() -> void:
	var bullet = $PelletSpawner.spawn()
	bullet.scale.x = order[ind]
	ind += 1
	if ind >= order.size():
		$RushTimer.stop()

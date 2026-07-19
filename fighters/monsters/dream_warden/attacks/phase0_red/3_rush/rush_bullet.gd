extends Node2D

func _process(delta: float) -> void:
	var movement = Global.soul.global_position - Global.soul.last_position
	
	if not $GenericPellet/CollisionShape2D2:
		queue_free()
		return
	if sign(movement.x) == -sign(scale.x):
		$GenericPellet/CollisionShape2D2.disabled = true
	else:
		$GenericPellet/CollisionShape2D2.disabled = false

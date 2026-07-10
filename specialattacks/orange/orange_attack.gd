extends Node2D

func _process(delta: float) -> void:
	var speed = (Global.soul.behaviors[0].cam_scroll_speed * delta)
	$Track.global_position.y += speed
	$Parallax2D.scroll_offset.y += speed

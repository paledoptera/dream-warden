extends Node3D

@export var player_sprite: Node3D

func set_rot() -> void:
	var target = player_sprite.global_position
	target.y = 0.0
	look_at_from_position(Vector3.ZERO,target)

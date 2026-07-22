extends Node3D

@export var player_sprite: Sprite3D
@export var model: Node3D
var target_position: Vector3 = Vector3.ZERO
@export var rot_speed: float = 7.0

func _process(delta: float) -> void:
	var pos = model.global_position
	pos.y = model.global_position.y
	target_position = target_position.slerp(player_sprite.global_position,rot_speed*delta)
	model.look_at_from_position(model.global_position,target_position)
	model.rotate_y(deg_to_rad(180.0))

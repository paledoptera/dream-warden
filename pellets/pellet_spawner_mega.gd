extends Node2D
class_name PelletSpawnerMega

@export var pellet: PackedScene
@export var spawnpoints: Array[Marker2D]

func spawn(spawn_position: Vector2 = global_position, aim_position:= Vector2.ZERO, parent: Node = get_parent()) -> Array[Node]:
	if aim_position != Vector2.ZERO:
		look_at(aim_position)
	
	global_position = spawn_position
	
	var bullets: Array[Node] = []
	
	for i in spawnpoints:
		var spawn_pos = i.global_position
		var spawn_rot = i.global_rotation
		var pellet_inst = pellet.instantiate()
		parent.add_child(pellet_inst)
		bullets.append(pellet_inst)
		pellet_inst.global_position = spawn_pos
		pellet_inst.global_rotation = spawn_rot
		pellet_inst.pellet.velocity = pellet_inst.pellet.velocity.rotated(pellet_inst.global_rotation)
	
	return bullets

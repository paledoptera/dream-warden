extends Node2D
class_name PelletSpawner

@export var pellet: PackedScene

func spawn(spawn_position: Vector2 = global_position, parent: Node = get_parent()) -> Node:
	var pellet_inst = pellet.instantiate()
	parent.add_child(pellet_inst)
	pellet_inst.global_position = spawn_position
	return pellet_inst

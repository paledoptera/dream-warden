extends Node2D

var start_pos : Node2D
var end_pos : Node2D

@export var line: Line2D
@export var marker: Marker2D
@export var collision_shape: CollisionShape2D

func _ready() -> void:
	$AnimationPlayer.play("blast")

func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	if not line:
		return
	line.set_point_position(0,start_pos.global_position)
	line.set_point_position(1,end_pos.global_position)
	
	var marker_pos = (line.get_point_position(0) + line.get_point_position(1))/2
	marker.global_position = marker_pos
	
	for i in line.get_children():
		if i is Line2D:
			i.set_point_position(0,line.get_point_position(0))
			i.set_point_position(1,line.get_point_position(1))
	
	collision_shape.shape.a = start_pos.global_position
	collision_shape.shape.b = end_pos.global_position

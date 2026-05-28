extends Node2D

var start_pos := Vector2(100.0,100.0)
var end_pos := Vector2(200.0,300.0)

@export var line: Line2D
@export var marker: Marker2D
@export var collision_shape: CollisionShape2D

func _ready() -> void:
	global_position = Vector2.ZERO
	line.set_point_position(0,start_pos)
	line.set_point_position(1,end_pos)
	
	var marker_pos = (line.get_point_position(0) + line.get_point_position(1))/2
	marker.global_position = marker_pos
	
	for i in line.get_children():
		if i is Line2D:
			i.set_point_position(0,line.get_point_position(0))
			i.set_point_position(1,line.get_point_position(1))
	
	collision_shape.shape.a = start_pos/10
	collision_shape.shape.b = end_pos/10
	
	$AnimationPlayer.play("blast")

extends Node3D
class_name Warden

#@onready var warden_meshes = $warden/rig/Skeleton3D
@onready var animation_player = $warden/AnimationPlayer
#@onready var meshes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for mesh in warden_meshes.get_children():
		#meshes.append(mesh)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# probably stupid. 
	animation_player.queue("warden_idle")
	pass

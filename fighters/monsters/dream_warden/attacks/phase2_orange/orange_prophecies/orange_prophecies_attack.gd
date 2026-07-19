extends Node2D

func _ready() -> void:
	Global.soul.assign_heart_properties(SoulType.ORANGE)
	Global.soul.visually_rotate(180)

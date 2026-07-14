extends Panel

func _ready() -> void:
	var cage = Global.battle.soul_cage.panel
	size = cage.size-(Vector2.ONE*12.0)
	global_position = cage.global_position+(Vector2.ONE*6.0)

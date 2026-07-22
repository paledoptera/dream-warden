extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Global.battle:
		return
	Global.battle.bottom_panel.hide_health()
	Global.battle.tp_bar.slide_left()
	await get_tree().create_timer(0.2).timeout
	Global.battle.aqua_hud.slide_up()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

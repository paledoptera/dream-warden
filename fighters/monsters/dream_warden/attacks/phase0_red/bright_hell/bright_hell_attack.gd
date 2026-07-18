extends Node2D

@export var start_pos: Array[Marker2D]
@export var end_pos: Array[Marker2D]

@export var lerp_strength: float = 1.0

func _ready() -> void:
	global_position = Vector2.ZERO
	var cage = Global.battle.soul_cage.panel
	$Cage.size = cage.size-(Vector2.ONE*12.0)
	$Cage.global_position = cage.global_position+(Vector2.ONE*6.0)

func _physics_process(_delta: float) -> void:
	$WardenSprite.global_position.y = lerp($WardenSprite.global_position.y,Global.soul.global_position.y,0.1*lerp_strength)
	$AimCrosshair.global_position = $AimCrosshair.global_position.lerp(Global.soul.global_position+(Global.soul.velocity),0.05*lerp_strength)
	$WardenSprite.look_at($AimCrosshair.global_position)

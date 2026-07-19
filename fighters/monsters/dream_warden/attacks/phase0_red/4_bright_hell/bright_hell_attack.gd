extends Node2D


@export var spawnpoints: Array[Marker2D]
@export var laser_bullet: Node2D
@export var warden: Node2D
var last

func _on_timer_timeout() -> void:
	
	$SideSwapper.scale.y = [-1.0,1.0].pick_random()
	
	var valid_spawnpoints = spawnpoints.duplicate()
	if last:
		valid_spawnpoints.erase(last)
	var spawnpoint = valid_spawnpoints.pick_random()
	
	last = spawnpoint
	var bul = $BulletSpawner.spawn(spawnpoint.global_position)
	var spr = bul.pellet.get_node("AnimatedSprite2D")
	spr.flip_h = [true, false].pick_random()
	spr.flip_v = [true,false].pick_random()
	
	


@export var start_pos: Array[Marker2D]
@export var end_pos: Array[Marker2D]

@export var lerp_strength: float = 1.0

func _ready() -> void:
	global_position = Vector2.ZERO
	var cage = Global.battle.soul_cage.panel
	$Cage.size = cage.size-(Vector2.ONE*12.0)
	$Cage.global_position = cage.global_position+(Vector2.ONE*6.0)

func _physics_process(_delta: float) -> void:
	laser_bullet.global_position = warden.global_position
	laser_bullet.global_rotation = warden.global_rotation
	$AimCrosshair.global_position = $AimCrosshair.global_position.lerp(Global.soul.global_position+(Global.soul.velocity/10),0.05*lerp_strength)
	$WardenSprite.look_at($AimCrosshair.global_position)

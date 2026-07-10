extends Area2D
class_name Pellet

signal justice_shotted(shot_direction : float)

@export var damage := 1
## The amount of TP gained by grazing
@export var graze_points := 5
## How much the turn timer is reduced when grazing (in seconds)
@export var time_points := 5.0 / 30.0
##Whether the pellet is repelled by a shield.
@export var shield_repelled : bool = false
##Whether the pellet is destroyed by yellow soul bullets.
@export var anti_justice : bool = false
##Whether the pellet gets destroyed if it collides
@export var destructible: bool = false
##If the pellet can be dashed into with the orange soul
@export var dashable: bool = false
var grazed := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Soul:
		if Global.soul.current_soul_type == SoulType.ORANGE and dashable:
			if check_dash(): 
				dash_destroy()
				return
			
		
		body.hurt(damage)
		if destructible:
			destroy()

func check_dash() -> bool:
	var soulmode = Global.soul.behaviors[0]
	if soulmode.dashstate == soulmode.DashState.DASHING:
		soulmode.cam_scroll_speed = 540
		soulmode.dash_timer = 20.0
		soulmode.dash_timer_max_visual = 20.0
		soulmode.dash_flash = 16.0
		soulmode.dash_flash_max = 16.0
		return true
	else: return false

func dash_destroy() -> void:
	queue_free()

func destroy() -> void:
	queue_free()

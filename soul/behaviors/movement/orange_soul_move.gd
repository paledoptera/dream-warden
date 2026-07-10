extends SoulMove

enum DashState {IDLE, CHARGING, DASHING}

var vsp : float = 240
var vsp_base: float = 240
var vsp_max: float = 240
var charge : float = 0.0
var charge_max: float = 10.0
var charge_timer: float = 0.0
var cam_scroll_speed: float = 330
var cam_scroll_speed_base: float = 330

var base_pos: float = 0.0
var dash : int = 0
var dash_timer: float = 0.0
var dash_timer_target: float = 0.0
var dash_timer_max_visual: float = 0.0
var dash_flash: float = 0.0
var dash_flash_max: float = 0.0
var dashstate := DashState.IDLE
var afterimage_mult: float = 0.5




@export var jump_speed_multiplier : float = 1.2
@export var max_air_time : float = 0.3

var current_air_time : float = 0

func start() -> void:
	speed = 8 * 30.0
	
	soul.position.y = 233
	soul.orange_effects.visible = true
	base_pos = soul.position.y
	soul.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	set_axis(MoveAxis.X)

func tick(delta:float) -> void:
	super.tick(delta)
	print("VSP: ", vsp)
	
	speed = 8 * 30.0
	
	var afterimage = preload("uid://cwnac2qb2d3sg").instantiate()
	add_child(afterimage)
	afterimage.global_position = soul.global_position
	print("afterimage ,", afterimage)
	
	
	if dashstate == DashState.IDLE:
		afterimage_mult = 0.5
		cam_scroll_speed = cam_scroll_speed_base
		if Input.is_action_pressed("confirm"):
			dashstate = DashState.CHARGING
	
	if dashstate == DashState.CHARGING:
		speed *= 0.83333333
		charge_timer = move_toward(charge_timer, 16.0, 1.0);
		afterimage_mult = lerp(afterimage_mult,0.0,charge_timer/16.0)
		
		cam_scroll_speed = cam_scroll_speed_base - ((min(charge_timer,8) * 0.5)*30.0)
		
		if Input.is_action_just_released("confirm"):
			var boost = (5+(charge_timer*0.5))
			print("BOOST: ", boost)
			boost = max(boost,7.0)
			
			cam_scroll_speed = cam_scroll_speed_base+ boost*30.0
			print("NEW SPEED", cam_scroll_speed)
			
			dash_timer = 4.0 + charge_timer
			dash_timer = max(dash_timer,10.0)
			dash_timer_max_visual = dash_timer
			dash_flash_max = charge_timer
			print("dash_timer = ", dash_timer, "charge_timer", charge_timer)
			charge_timer = 0.0
				
			dashstate = DashState.DASHING
			Sounds.play("snd_chargeshot_fire",0.5)

	if dashstate == DashState.DASHING:
		afterimage_mult = lerp(5.0,0.5,(20.0-(dash_timer))/20.0)
		dash_timer -= 30.0 * delta
		
		dash_flash = lerp(dash_flash_max,0.0,1.0-dash_timer/dash_timer_max_visual)
		
		cam_scroll_speed = lerp(cam_scroll_speed,cam_scroll_speed_base,0.05)
		
		if (dash_timer <= 0.0):
			vsp = vsp_base
			dashstate = DashState.IDLE
			
 #with (obj_orangeheart_bullet)
			#{
				#if (x > (other.x + 20))
				#{
					#if (variable_instance_exists(id, "i_am_a_glove"))
						#orangeheartControlled = true;
				#}
			#}
			#
			#if (chargetimer == 16)
			#{
				#snd_stop(loop_sound);
				#snd_play(snd_explosion_mmx3, 0.5, 2);
				#chargecon = 2;
				#dashtimer = 0;
			#}
			#else
			#{
				#chargetimer = 8 + (chargetimer * 0.5);
				#snd_stop(loop_sound);
				#snd_play(snd_explosion_mmx3, 0.5, 2);
				#chargecon = 2;
				#dashtimer = 0;
			#}
	
	
	
		
	
	if !soul.is_on_floor():
		if current_air_time > 0.0:
			current_air_time -= delta
	else:
		current_air_time = max_air_time


func should_ascend() -> bool:
	return Input.is_action_pressed("up") && current_air_time > 0.0

extends Monster
class_name DreamWarden

const SPECIAL_ATTACK = preload("uid://dbi6lj71m2qh8")
@export var ultra_3d_world: SubViewport

var starting_pos: Vector2
var block_attacks: bool = true
var turn: int = -1
var phase: int = 1
var flavortext_line: int = 0


func _ready() -> void:
	super()
	starting_pos = global_position


func do_animation(p_animation: Animations) -> Signal:
	match p_animation:
		Animations.HURT:
			$AnimationPlayer.play("block")
			
			await get_tree().create_timer(1.0).timeout
			Sounds.play("snd_ward_hit")
			#velocity = 0.0
			#squishing = false
		Animations.SPARE:
			$AnimationPlayer.play("spare")
			
		Animations.FAINT:
			$AnimationPlayer.play("die")
		
		Animations.SPECIAL1:
			$Actions.play("block")
			await get_tree().create_timer(0.4).timeout
			Sounds.play("snd_ward_deflect")
			
	return $AnimationPlayer.animation_finished

func instantiate_3d_attack(scene: PackedScene) -> void:
	var attack := scene.instantiate()
	
	ultra_3d_world.add_child(attack)
	
	attacks.append(attack)

func start_attack() -> float:
	phase = 2
	
	match phase:
		1: # Red Soul
			turn += 1
			turn = wrapi(turn,0,5)
			
			animate("attack_start")
			
			match turn:
					0: # Wings
						goto_center_screen()
						instantiate_attack(preload("uid://cuwui318cvb75")) # wings
						flavortext_line = 0
						return 8.0
					1: # Beam
						goto_center_screen()
						instantiate_attack(preload("uid://q3t3r8c6t065")) # beam
						flavortext_line = 1
						return 8.5
					2: # Revolve
						goto_center_screen()
						instantiate_attack(preload("uid://cp8jvyn2dnnpv")) # revolve
						flavortext_line = 2
						return 10.0
					3: # Rush
						goto_center_screen()
						instantiate_attack(preload("uid://p5rdsyjnb42d")) # rush
						flavortext_line = 3
						return 5.0
					4: # Bright Hell
						instantiate_attack(preload("uid://bqj31vq3siu3")) # bright_hell
						flavortext_line = 4
						return 8.0
	
		2: # Aqua Soul
			turn = 0
			match turn:
				0: # 3d Attack
					instantiate_3d_attack(SPECIAL_ATTACK)
					owner.animations.play("slide_down")
					return 9999.0
					#6:
						#goto_center_screen()
						#instantiate_attack(preload("uid://biy34d1rdl0yb")) # orange_prophecies_attack
						#return 8.0
					#8:
						#goto_center_screen()
						#instantiate_attack(preload("uid://2wd3u53cs71a")) # orange_wings_attack
#
						#return 8.0
					#
					#7:
						#pass
						#instantiate_3d_attack(SPECIAL_ATTACK)
						#owner.animations.play("slide_down")
	
	
			
	return 8.0

func end_attack() -> void:
	super()
	goto_starting_pos()
	$AnimationPlayer.play_backwards("attack_start")
	$AnimationPlayer.queue("idle")

func get_idle_line() -> Dialogue:
	var line = idle_lines[flavortext_line].duplicate()
	if Global.tp >= 250.0:
		line.text += str("\n  * (You can use UNLEASH!)")
		print("UNLEASH:", line.text.find("UNLEASH"))
		var yellow_gradient = GradientMarker.new()
		yellow_gradient.start_char = line.text.find("UNLEASH")
		yellow_gradient.end_char = yellow_gradient.start_char + 6
		yellow_gradient.texture = preload("uid://cjff5uju5g06g")
		line.markers.append(yellow_gradient)
	
	return line
	
	

func goto_center_screen() -> void:
	var tween = create_tween()
	tween.tween_property(self,"global_position",get_viewport().get_camera_2d().get_screen_center_position()+Vector2(0.0,-50),0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func goto_starting_pos() -> void:
	var tween = create_tween()
	tween.tween_property(self,"global_position",starting_pos,2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	

func animate(animation_name: String, play_backwards: bool = false) -> void:
	if play_backwards:
		$AnimationPlayer.play_backwards(animation_name)
		$"3DSprite/SubViewport/warden/warden/AnimationPlayer".play_backwards(animation_name)
		return
	$AnimationPlayer.play(animation_name)
	$"3DSprite/SubViewport/warden/warden/AnimationPlayer".play(animation_name)

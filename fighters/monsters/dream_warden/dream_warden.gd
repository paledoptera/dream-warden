extends Monster

const SPECIAL_ATTACK = preload("uid://dbi6lj71m2qh8")
@export var ultra_3d_world: SubViewport

var starting_pos: Vector2
var turn: int = -1

func _ready() -> void:
	super()
	starting_pos = global_position


func do_animation(p_animation: Animations) -> Signal:
	match p_animation:
		Animations.HURT:
			$AnimationPlayer.play("hurt")
			await get_tree().create_timer(0.1).timeout
			Sounds.play("snd_ward_hit")
			#velocity = 0.0
			#squishing = false
		Animations.SPARE:
			$AnimationPlayer.play("spare")
			
		Animations.FAINT:
			$AnimationPlayer.play("die")
	return $AnimationPlayer.animation_finished

func instantiate_3d_attack(scene: PackedScene) -> void:
	var attack := scene.instantiate()
	
	ultra_3d_world.add_child(attack)
	
	attacks.append(attack)

func start_attack() -> float:
	
	turn += 1
	turn = wrapi(turn,0,2)
	
	match turn:
		0:
			goto_center_screen()
			$AnimationPlayer.play("attack_start")
			instantiate_attack(preload("uid://cuwui318cvb75"))
			#instantiate_3d_attack(SPECIAL_ATTACK)
			#owner.animations.play("slide_down")
			return 8.0
		1:
			goto_center_screen()
			$AnimationPlayer.play("attack_start")
			instantiate_attack(preload("uid://q3t3r8c6t065"))
			return 10.0
	return 8.0

func end_attack() -> void:
	super()
	goto_starting_pos()
	$AnimationPlayer.play_backwards("attack_start")
	$AnimationPlayer.queue("idle")

func goto_center_screen() -> void:
	var tween = create_tween()
	tween.tween_property(self,"global_position",get_viewport().get_camera_2d().get_screen_center_position()+Vector2(0.0,-50),0.5).set_ease(Tween.EASE_IN_OUT)

func goto_starting_pos() -> void:
	var tween = create_tween()
	tween.tween_property(self,"global_position",starting_pos,0.5).set_ease(Tween.EASE_IN_OUT)
	

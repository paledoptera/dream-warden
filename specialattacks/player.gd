extends Area3D

@export var stage: Node3D
@export var anim: AnimationPlayer
@export var action_anim: AnimationPlayer
var attacking: bool = false
var jumping: bool = false
var y_position: float = 0.0
var y_velocity: float = 0.0
var jump_speed: float = 2.2
var grav_speed: float = 0.22
enum State {GROUND, FALLING, JUMPING, CROUCHING, ATTACKING, ROLLING}
var state = State.GROUND
var airborne: bool = false
var move_speed: float = 2
var roll_progress: float = 0.0
@export var bkg: Node3D

func _process(delta: float) -> void:
	var aqua_afterimage = preload("uid://cev8j51xyelxs").instantiate()
	get_owner().add_child(aqua_afterimage)
	aqua_afterimage.global_position = $Pivot/Susie/Soul.global_position
	
	
	var move = Input.get_axis("left","right")
	var move_right_release = Input.is_action_just_released("right")
	var attack = Input.is_action_just_pressed("cancel")
	var jump = Input.is_action_just_pressed("confirm")
	var jump_held = Input.is_action_pressed("confirm")
	var jump_release = Input.is_action_just_released("confirm")
	var crouch = Input.is_action_pressed("down")
	
	
	if state == State.GROUND or state == State.ROLLING:
		if crouch:
			state = State.CROUCHING
		if attack:
			anim.stop()
			anim.play("slash")
			state = State.ATTACKING
			var tween = create_tween()
			await get_tree().create_timer(0.4).timeout
			state = State.GROUND
		elif jump:
			y_velocity = jump_speed
			state = State.JUMPING
			airborne = true
	
	if state == State.ATTACKING:
		return


	
	if not airborne:
		jumping = false
		y_velocity = 0.0
		if state == State.FALLING or state == State.JUMPING:
			state = State.GROUND
	else:
		y_position += y_velocity * delta
		y_position = max(y_position,0.0)
		y_velocity -= (grav_speed)
		
		if y_position == 0.0:
			airborne = false

	if jump_release:
		print("JUMP RELEASE")
		if y_velocity > 0.0:
			y_velocity *= 0.25
	
	if y_velocity > 0.0:
		animate_with_transition("jump","fall")
	elif y_velocity < 0.0:
		animate_with_transition("jump","fall")
	
	elif move > 0.0:
		if state != State.ROLLING:
			anim.stop()
			anim.play("roll_right")
			state = State.ROLLING
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(get_parent(),"rotation",get_parent().rotation+Vector3(0.0,deg_to_rad(60.0),0.0),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(bkg,"rotation",bkg.rotation+(Vector3(0.0,deg_to_rad(50.0),0.0)),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			await get_tree().create_timer(0.3).timeout
			state = State.GROUND
	elif move < 0.0:
		if state != State.ROLLING:
			anim.stop()
			anim.play("roll_left")
			state = State.ROLLING
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(get_parent(),"rotation",get_parent().rotation+Vector3(0.0,deg_to_rad(-60.0),0.0),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(bkg,"rotation",bkg.rotation+(Vector3(0.0,deg_to_rad(-50.0),0.0)),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			await get_tree().create_timer(0.4).timeout
			state = State.GROUND

		
		
	if y_velocity == 0.0 and state == State.GROUND:
		if not playing_current_anims(["roll_left", "roll_right"]):
			animate("idle")
	
	
	global_position.y = y_position

	#stage.rotation.y += move * move_speed * delta
	
	if state != State.GROUND:
		return

func playing_current_anims(arr: Array):
	for i in arr:
		if anim.current_animation == i and anim.is_playing():
			return true
	return false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"crouch":
			state = State.GROUND

func animate(anim_name: StringName):
	if anim.current_animation == anim_name:
		return
	anim.stop()
	anim.play(anim_name)

func animate_with_transition(trans_name: StringName, anim_name: StringName):
	if anim.current_animation == trans_name or anim.current_animation == anim_name:
		return
	anim.stop()
	anim.play(trans_name)
	anim.queue(anim_name)

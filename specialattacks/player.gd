extends Area3D

@export var stage: Node3D
@export var anim: AnimationPlayer
@export var action_anim: AnimationPlayer
var attacking: bool = false
var jumping: bool = false
var y_position: float = 0.0
var y_velocity: float = 0.0
var jump_speed: float = 3.5
var grav_speed: float = 0.6
enum State {GROUND, FALLING, JUMPING, CROUCHING, ATTACKING}
var state = State.GROUND
var airborne: bool = false
var move_speed: float = 2

func _process(delta: float) -> void:
	var move = Input.get_axis("left","right")
	var attack = Input.is_action_just_pressed("confirm")
	var jump = Input.is_action_just_pressed("up")
	var jump_held = Input.is_action_pressed("up")
	var crouch = Input.is_action_pressed("down")
	
	if state == State.GROUND:
		if crouch:
			anim.play("crouch")
			state = State.CROUCHING
		elif jump:
			y_velocity = jump_speed
			state = State.JUMPING
			airborne = true
			action_anim.play("jump")
	
	if attack:
		attacking = true
		action_anim.stop()
		action_anim.play("slash")

	
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

		if not jump_held and jumping:
			if y_velocity > 0.0:
				y_velocity *= 0.5
	
	
	global_position.y = y_position
	stage.rotation.y += move * move_speed * delta
	
	if state != State.GROUND:
		return
	
	if move != 0.0 and anim.current_animation != "slash":
		anim.play("running")
	else:
		anim.play("idle")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"crouch":
			state = State.GROUND
	

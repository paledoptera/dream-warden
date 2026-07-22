extends Node2D
class_name Battle

@export var animations: AnimationPlayer
@export var soul: Soul
@export var soul_cage: StaticBody2D
@export var bottom_panel: Node2D
@export var tp_bar: Node2D
@export var aqua_hud: Node2D

var in_attack := false
var turn_timer := 0.0


var total_money := 0
var total_xp := 0
var money_multiplier := 0.0

func _enter_tree() -> void:
	Global.battle = self
	Global.characters.append($Characters/Susie)
	Global.monsters.append($Monsters/DreamWarden)

func _ready() -> void:
	for item in Global.items:
		if item.usePredicate.item == null:
			item.usePredicate.item = item
	#set_positions($Characters, Global.characters, Vector2(108.0, 0.0))
	#set_positions($Monsters, Global.monsters, Vector2(640.0 - 108.0, 0.0))
	Global.display_text.emit(Global.get_opening_line())
	Global.monster_killed.connect(monster_killed)
	
	for monster: Monster in Global.monsters:
		total_money += monster.money_dropped
		total_xp += monster.xp_bled
		money_multiplier += monster.get_value_from_stat(AbstractFighter.Stats.MONEY_MULTIPLIER)
	
	for player: Character in Global.characters:
		money_multiplier += player.get_value_from_stat(AbstractFighter.Stats.MONEY_MULTIPLIER)
	
	Global.tp = 0.0
	
	Sounds.play("snd_impact", 0.7)
	Sounds.play("snd_weaponpull_fast", 0.8)
	Sounds.set_music("mus_warden_ex", 0.4)

func _process(p_delta: float) -> void:
	if in_attack:
		turn_timer -= p_delta
		if turn_timer <= 0.0:
			in_attack = false
			end_attack()

func set_positions(p_parent: Node, p_nodes: Array, p_offset := Vector2.ZERO):
	var size := p_nodes.size()
	if size == 1:
		var node: Node2D = p_nodes[0]
		p_parent.add_child(node)
		node.position = Vector2(0.0, Global.CENTER.y) + p_offset
	elif size == 2:
		var node_1: Node2D = p_nodes[0]
		var node_2: Node2D = p_nodes[1]
		p_parent.add_child(node_1)
		p_parent.add_child(node_2)
		node_1.position = Vector2(0.0, Global.CENTER.y - 48.0) + p_offset
		node_2.position = Vector2(0.0, Global.CENTER.y + 96.0 - 48.0) + p_offset
	else:
		for i: int in size:
			var node: Node2D = p_nodes[i]
			p_parent.add_child(node)
			node.position.x = 0.0
			node.position.y = Global.CENTER.y - 96.0 + 2.0 * 96.0 * i / (size - 1)
			node.position += p_offset

func start_attack() -> void:
	play_heart_animation()
	soul.position = ($Characters.get_child(0) as Character).position
	soul.visible = true
	var tween := get_tree().create_tween()
	tween.tween_property(soul, "position", Global.CENTER, 0.25)
	soul_cage.expand()
	await soul_cage.finished_animation
	soul.active = true
	
	var alive_monsters: Array[Monster] = []
	for monster: Monster in Global.monsters:
		if monster != null:
			alive_monsters.append(monster)
	if alive_monsters.is_empty():
		return
	var monster: Monster = alive_monsters.pick_random()
	turn_timer = monster.start_attack()
	in_attack = true

func end_attack(p_continue_battle := true) -> void:
	for monster: Monster in Global.monsters:
		if monster != null:
			monster.end_attack()
	
	soul.active = false
	var tween := get_tree().create_tween()
	tween.tween_property(soul, "position", ($Characters.get_child(0) as Character).position, 0.25)
	tween.finished.connect(play_heart_animation)
	soul_cage.contract()
	await soul_cage.finished_animation
	if p_continue_battle:
		bottom_panel.current_char = -1
		for char_menu: CharMenu in bottom_panel.char_menus:
			char_menu.selected_item = 0
		bottom_panel.start_turn()
		Global.display_text.emit(Global.get_idle_line())

func play_heart_animation() -> void:
	soul.visible = false

func hurt(p_damage: int) -> void:
	var alive_characters: Array[Character] = []
	for character: Character in Global.characters:
		if character.alive:
			alive_characters.append(character)
	if alive_characters.is_empty():
		return
	var character: Character = alive_characters.pick_random()
	character.hurt(p_damage)
	if alive_characters.size() == 1 and !character.alive:
		await character.faint_finished
		Global.change_to_scene("res://scenes/menus/lost_screen/lost_screen.tscn")
		Sounds.play("snd_break2", 0.6)

func monster_killed(p_monster: Monster, p_context: Global.DefeatContext) -> void:
	if p_context != Global.DefeatContext.SNOWGRAVED:
		total_xp -= p_monster.xp_bled
	
	var monsters_dead := true
	for monster: Monster in Global.monsters:
		if monster != null:
			monsters_dead = false
			break
	if monsters_dead:
		bottom_panel.continue_battle = false
		bottom_panel.get_node("AttackTiming").focused = false
		for character: Character in Global.characters:
			character.do_animation(Character.Animations.IDLE)
		var money := (total_money * Global.chapter / 4) * money_multiplier
		Global.display_text.emit("  * You won!\n[color=#000]----[/color]Got %d EXP and %dD$." % [total_xp, money], true)
		await Global.text_finished
		Global.change_to_scene("res://scenes/menus/win_screen/win_screen.tscn")

func move_camera(new_position: Vector2, time: float = 0.5, ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT, trans: Tween.TransitionType = Tween.TransitionType.TRANS_CUBIC):
	var tween = create_tween()
	tween.tween_property($Camera2D,"position",new_position,time).set_ease(ease).set_trans(trans)

func move_soul_cage(new_position: Vector2, time: float = 0.5, global_coords: bool = false, ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT, trans: Tween.TransitionType = Tween.TransitionType.TRANS_CUBIC):
	var tween = create_tween()
	var pos = new_position
	if not global_coords:
		pos += soul_cage.position
	tween.tween_property(soul_cage,"position",pos,time).set_ease(ease).set_trans(trans)

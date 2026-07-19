extends Spell
class_name SpellUnleash


func do_spell(p_from: Character, _p_to: Node2D) -> void:
	Global.display_text.emit(dialogue)
	await Global.text_finished
	var susie = Global.characters[0]
	susie.animation_player.play("unleash")
	await susie.animation_player.animation_finished
	p_from.spell_finished.emit()

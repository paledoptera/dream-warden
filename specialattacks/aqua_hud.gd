extends Sprite2D


func slide_up() -> void:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(320.0,470.0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func slide_down() -> void:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(473.0,515.0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

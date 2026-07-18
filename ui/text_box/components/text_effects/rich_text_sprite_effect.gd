class_name RichTextSpriteEffect
extends RichTextPlacementEffect

@export var texture: Texture2D
@export var sprite_scale := Vector2.ONE
@export var offset := Vector2.ZERO
var sprite: Sprite2D


func place_element() -> void:
	sprite = Sprite2D.new()
	rtl.add_child(sprite)
	
	
	var text_rect = get_text_rect(start_char,end_char)
	sprite.position = text_rect.position + position
	sprite.offset = offset
	sprite.scale = sprite_scale
	sprite.texture = texture
	sprite.visible = false

func _process(delta: float) -> void:
	if rtl.visible_characters >= start_char:
		sprite.visible = true
	else:
		sprite.visible = false
	

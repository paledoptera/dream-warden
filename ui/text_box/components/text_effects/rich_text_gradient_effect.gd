class_name RichTextGradientEffect
extends RichTextPlacementEffect

@export var texture: GradientTexture2D


func place_element() -> void:
	var new_rect = TextureRect.new()
	rtl.add_child(new_rect)
	
	var text_rect = get_text_rect(start_char,end_char)
	new_rect.position = text_rect.position + position
	new_rect.size = text_rect.size
	new_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_rect.texture = texture
	
	if not debug:
		rtl.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW

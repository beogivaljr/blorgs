extends LineEdit



func _on_GameCode_text_changed(new_text: String) -> void:
	text = new_text.to_upper()
	caret_position = new_text.length()

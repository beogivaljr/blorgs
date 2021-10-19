extends VBoxContainer

signal cancel



func _on_Button_pressed() -> void:
	emit_signal("cancel")

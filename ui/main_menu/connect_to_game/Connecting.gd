extends VBoxContainer

signal canceled


func _on_Button_pressed() -> void:
	emit_signal("canceled")

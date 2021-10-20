extends Spatial

signal on_nextLevel


func _on_Button_pressed() -> void:
	emit_signal("on_nextLevel")

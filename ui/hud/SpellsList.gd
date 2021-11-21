extends VBoxContainer

signal spell_selected


func _on_Button_toggled(button_pressed):
	if button_pressed:
		show()
	else:
		hide()


func _on_spell_selected():
	emit_signal("spell_selected")

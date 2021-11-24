extends HBoxContainer


func _on_SelectButton_pressed():
	for child in get_children():
		child.disabled = true
		child.set_focus_mode(Control.FOCUS_NONE)

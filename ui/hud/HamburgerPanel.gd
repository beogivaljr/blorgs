extends PanelContainer


func _on_HamburgerButton_toggled(button_pressed):
	if button_pressed:
		show()
	else:
		hide()


func _on_HamburgerButton_pressed():
	if visible:
		hide()
	else:
		show()

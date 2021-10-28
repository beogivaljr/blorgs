extends Panel


func _ready():
	pass


func _on_HamburgerButton_toggled(button_pressed):
	if button_pressed:
		show()
	else:
		hide()

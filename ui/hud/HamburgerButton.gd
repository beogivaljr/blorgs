extends Button


func _ready():
	if $"../../HamburgerPanel".visible:
		text = "<"
		pressed = true
	else:
		text = ">"
		pressed = false


func _on_HamburgerButton_toggled(button_pressed):
	if button_pressed:
		text = "<"
	else:
		text = ">"


func _on_HamburgerButton_pressed():
	if $"../../HamburgerPanel".visible:
		text = "<"
		pressed = true
	else:
		text = ">"
		pressed = false

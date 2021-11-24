extends Button


export var button_name = "Name"
signal button_renamed(new_name)


func _ready():
	$Popup/LineEdit.set_text(button_name)


func _on_LineEdit_text_entered(new_text = null):
	self.pressed = false
	emit_signal("button_renamed", new_text)
	set_focus_mode(Control.FOCUS_ALL)
	$Popup.call_deferred("hide")


func _on_RenameButton_toggled(button_pressed: bool):
	if button_pressed:
		set_focus_mode(Control.FOCUS_NONE)
		$Popup/LineEdit.grab_focus()
		$Popup/LineEdit.select_all()
		$Popup.show()
	else:
		_on_LineEdit_text_entered($Popup/LineEdit.text)

extends LineEdit


func _ready():
	set_text($"../..".button_name)


func _on_EditButton_pressed():
	$"../..".set_focus_mode(Control.FOCUS_NONE)
	grab_focus()
	select_all()
	$"..".show()


func _on_LineEdit_text_entered(new_text):
	$"../..".set_focus_mode(Control.FOCUS_ALL)
	$"..".call_deferred("hide")


func _on_RenameButton_toggled(button_pressed):
	if button_pressed:
		$"../..".set_focus_mode(Control.FOCUS_NONE)
		grab_focus()
		select_all()
		$"..".show()
	else:
		emit_signal("text_entered", text)

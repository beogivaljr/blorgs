extends LineEdit


func _on_EditButton_pressed():
	$"..".focus_mode = Control.FOCUS_NONE
	show()
	editable = true


func _on_LineEdit_text_entered(new_text):
	$"..".text = new_text
	$"..".focus_mode = Control.FOCUS_ALL
	editable = false
	hide()

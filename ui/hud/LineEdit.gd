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
	$"..".hide()


func _on_RenameButton_minimum_size_changed():
	set_size(get_parent_area_size())

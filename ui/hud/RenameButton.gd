extends Button


export var button_name = "Name"
signal button_renamed(new_name)


func _on_LineEdit_text_entered(new_text):
	emit_signal("button_renamed", new_text)

extends VBoxContainer

signal spell_selected


func _ready():
	for button in get_children():
		button.connect("pressed", self, "_on_spell_selected",[button])


func _on_spell_selected(button):
	for other_button in get_children():
		if not other_button == button:
			other_button.pressed = false
	emit_signal("spell_selected", button.text)

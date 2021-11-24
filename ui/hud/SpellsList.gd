extends VBoxContainer


signal spell_selected(new_spell)
signal spell_renamed(spell)
signal spell_unselected

var selected_spell


func _on_spell_renamed(spell):
	if spell == selected_spell:
		emit_signal("spell_renamed", spell)


func _on_spell_selected(new_spell):
	if new_spell == selected_spell:
		selected_spell = null
		emit_signal("spell_unselected")
	else:
		selected_spell = new_spell
	
	emit_signal("spell_selected", new_spell)


func _on_spell_started():
	for spell_container in get_children():
		spell_container.disable_other_buttons(null)


func _on_spell_done():
	for spell_container in get_children():
		spell_container.enable_buttons()


func _on_spell_container_button_pressed(button):
	for spell in get_children():
			spell._on_any_button_pressed(button)

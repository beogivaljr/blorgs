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
	
	for spell in get_children():
		if not new_spell == spell:
			spell.deselect()
	
	emit_signal("spell_selected", new_spell)


func _on_function_started():
	for spell in get_children():
		spell.disable_buttons()


func _on_function_done():
	for spell_container in get_children():
		spell_container.enable_buttons()

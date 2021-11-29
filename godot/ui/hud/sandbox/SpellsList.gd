extends VBoxContainer


signal spell_selected(new_spell)
signal spell_renamed(spell)
signal spell_unselected

var _selected_spell: SpellDTO


func _on_spell_renamed(spell: SpellDTO):
	if spell == _selected_spell:
		emit_signal("spell_renamed", spell)


func _on_spell_selected(new_spell: SpellDTO):
	if new_spell == _selected_spell:
		_selected_spell = null
		emit_signal("spell_unselected")
	else:
		_selected_spell = new_spell
	
	emit_signal("spell_selected", new_spell)


func disable_buttons():
	for spell_container in get_children():
		spell_container.disable_other_buttons(null)


func enable_buttons():
	for spell_container in get_children():
		spell_container.enable_buttons()


func _on_spell_container_button_pressed(button: Button):
	for spell in get_children():
		spell.toggle_enable_other_buttons(button)

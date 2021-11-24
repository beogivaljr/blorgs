extends VBoxContainer


signal spell_selected(new_spell)
signal spell_renamed(spell)
signal spell_unselected

var selected_spell: SpellContainer


func _on_spell_renamed(spell: SpellContainer):
	if spell == selected_spell:
		emit_signal("spell_renamed", spell)


func _on_spell_selected(new_spell: SpellContainer):
	if new_spell == selected_spell:
		selected_spell = null
		emit_signal("spell_unselected")
	else:
		selected_spell = new_spell
	
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
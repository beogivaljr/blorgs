extends VBoxContainer


signal spell_selected(new_name)
signal spell_renamed(new_name)
signal spell_unselected

var selected_spell


func _on_spell_renamed(new_spell):
	if new_spell == selected_spell:
		emit_signal("spell_renamed", new_spell.spell_name)


func _on_spell_clicked(new_spell):
	if new_spell == selected_spell:
		selected_spell = null
		emit_signal("spell_unselected")
		print("AGUACATO")
	else:
		selected_spell = new_spell
	
	for spell in get_children():
		print(spell)
		if not new_spell == spell:
			spell.deselect()
	
	emit_signal("spell_selected", new_spell.spell_name)

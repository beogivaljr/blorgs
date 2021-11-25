extends PanelContainer


func _on_spell_unselected():
	call_deferred("hide")


func _on_spell_selected(new_spell: SpellContainer):
	if not new_spell:
		call_deferred("hide")
	else:
		$SelectedSpell.set_text("Selecione " + new_spell.spell.spell_name.parameter_name)
		show()


func display_failed_spell_message(spell_name: String):
	$SelectedSpell.set_text("Feitiço " + spell_name + " falhou")
	show()


func _on_rename_function_selected(new_spell: SpellContainer):
	$SelectedSpell.set_text("Renomeie a função " + new_spell.spell.spell_name.function_name)
	show()


func _on_rename_parameter_selected(new_spell: SpellContainer):
	$SelectedSpell.set_text("Renomeie o parâmetro " + new_spell.spell.spell_name.parameter_name)
	show()


func _on_spell_container_button_pressed(button: Button):
	if not button.pressed:
		hide()

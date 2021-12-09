extends PanelContainer


func _on_spell_unselected():
	call_deferred("hide")


func _on_spell_selected(new_spell: SpellDTO):
	if not new_spell:
		call_deferred("hide")
	else:
		$SelectedSpell.set_text("Selecione " + new_spell.name_dto.parameter)
		show()


func display_failed_spell_message(spell_name: String):
	$SelectedSpell.set_text("Feitiço " + spell_name + " falhou")
	show()


func _on_rename_function_selected(new_spell: SpellDTO):
	$SelectedSpell.set_text("Renomeie a função " + new_spell.name_dto.function)
	show()


func _on_rename_parameter_selected(new_spell: SpellDTO):
	$SelectedSpell.set_text("Renomeie o parâmetro " + new_spell.name_dto.parameter)
	show()


func _on_spell_container_button_pressed(button: Button):
	if not button.pressed:
		hide()

extends PanelContainer


func _on_spell_unselected():
	call_deferred("hide")


func _on_spell_selected(new_spell):
	if not new_spell:
		call_deferred("hide")
	else:
		$SelectedSpell.set_text("Selecione " + new_spell.spell_name.parameter_name)
		show()


func _on_rename_function_selected(new_spell):
	$SelectedSpell.set_text("Renomeie a função " + new_spell.spell_name.function_name)
	show()


func _on_rename_parameter_selected(new_spell):
	print(new_spell.spell_name.parameter_name)
	$SelectedSpell.set_text("Renomeie o parâmetro " + new_spell.spell_name.parameter_name)
	show()


func _on_spell_container_button_pressed(button):
	if not button.pressed:
		hide()


func _on_spell_started():
	hide()

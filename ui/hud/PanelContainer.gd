extends PanelContainer


func _on_spell_unselected():
	call_deferred("hide")


func _on_spell_selected(new_spell):
	$SelectedSpell.set_text("Selecione " + new_spell.spell_name.parameter_name)
	show()


func _on_rename_funcion_selected(new_spell):
	$SelectedSpell.set_text("Renomeie " + new_spell.spell_name.funcion_name)
	show()


func _on_spell_started():
	hide()

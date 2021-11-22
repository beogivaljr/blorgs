extends PanelContainer


func _on_spell_unselected():
	call_deferred("hide")


func _on_spell_selected(new_spell):
	$SelectedSpell.set_text("Selecione " + new_spell.spell_name[1])
	show()


func _on_spell_started():
	hide()

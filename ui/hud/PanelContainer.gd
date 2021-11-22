extends PanelContainer


func _ready():
	$"../SpellPanel/SpellsList".connect("spell_selected", self, "_on_spell_selected")
	$"../SpellPanel/SpellsList".connect("spell_renamed", self, "_on_spell_selected")
	$"../SpellPanel/SpellsList".connect("spell_unselected", self, "_on_spell_unselected")


func _on_spell_unselected():
	call_deferred("hide")


func _on_spell_selected(new_spell):
	$SelectedSpell.set_text("Selecione " + new_spell.spell_name[1])
	show()

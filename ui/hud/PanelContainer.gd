extends PanelContainer


func _ready():
	$"../SpellPanel/SpellsList".connect("spell_selected", self, "_on_spell_selected")
	$"../SpellPanel/SpellsList".connect("spell_renamed", self, "_on_spell_selected")
	$"../SpellPanel/SpellsList".connect("spell_unselected", self, "_on_spell_unselected")


func _on_spell_unselected():
	call_deferred("hide")


func _on_spell_selected(spell_name):
	$SelectedSpell.text = spell_name
	show()

extends PanelContainer


func _ready():
	$"../SpellPanel/SpellContainer/SpellsList".connect("spell_selected", self, "_on_spell_selected")


func _on_SelectedSpell_pressed():
	hide()


func _on_spell_selected():
	show()

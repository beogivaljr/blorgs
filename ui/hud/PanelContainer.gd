extends PanelContainer


func _ready():
	$"../SpellPanel/SpellsList".connect("spell_selected", self, "_on_spell_selected")


func _on_SelectedSpell_pressed():
	hide()


func _on_spell_selected(spell_name):
	get_child(0).text = spell_name
	show()

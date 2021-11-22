extends Control
var spellContainer = preload("res://ui/hud/SpellContainer.tscn")


signal spell_selected(function_id)

signal spell_started
signal spell_done


var spell_id_list = [GlobalConstants.SpellIds.MOVE_TO, GlobalConstants.SpellIds.USE_ELEVATOR]


func _ready():
	connect("spell_started", self, "_on_spell_started")
	connect("spell_done", self, "_on_spell_done")
	var spells = []
	for spell_id in spell_id_list:
		var spell = spellContainer.instance()
		spell.spell_id = spell_id
		$SpellPanel/SpellsList.add_child(spell)
		spell.connect("spell_selected", $SpellPanel/SpellsList, "_on_spell_selected")
		spell.connect("spell_container_button_pressed", $SpellPanel/SpellsList, "_on_spell_container_button_pressed")
		spell.connect("spell_selected", self, "_on_spell_selected")


func _on_spell_started():
	$SpellPanel/SpellsList._on_spell_started()
	$PanelContainer._on_spell_started()


func _on_spell_done():
	$SpellPanel/SpellsList._on_spell_done()


func _on_spell_selected(spell):
	emit_signal("spell_selected", spell.spell_id)

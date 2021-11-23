extends Control
var spellContainer = preload("res://ui/hud/SpellContainer.tscn")


signal spell_selected(function_id)

signal spell_started
signal spell_done


var spell_id_list = [
	GlobalConstants.SpellIds.MOVE_TO,
	GlobalConstants.SpellIds.USE_ELEVATOR,
	GlobalConstants.SpellIds.PRESS_ROUND_BUTTON,
	GlobalConstants.SpellIds.PRESS_SQUARE_BUTTON,
	GlobalConstants.SpellIds.TOGGLE_GATE,
	GlobalConstants.SpellIds.DESTROY_SUMMON,
	GlobalConstants.SpellIds.SUMMON_ASCENDING_PORTAL,
]


func setup(spell_ids_list):
	self.spell_ids_list = spell_ids_list


func _ready():
	connect("spell_started", self, "_on_spell_started")
	connect("spell_done", self, "_on_spell_done")
	var spells = []
	for spell_id in spell_id_list:
		var spell = spellContainer.instance()
		spell.spell_id = spell_id
		$SpellPanel/ScrollContainer/SpellsList.add_child(spell)
		
		spell.connect("spell_selected", $SpellPanel/ScrollContainer/SpellsList, "_on_spell_selected")
		spell.connect("spell_container_button_pressed", $SpellPanel/ScrollContainer/SpellsList, "_on_spell_container_button_pressed")
		
		spell.connect("spell_container_button_pressed", $PanelContainer, "_on_spell_container_button_pressed")
		spell.connect("spell_container_rename_function_pressed", $PanelContainer, "_on_rename_function_selected")
		spell.connect("spell_container_rename_parameter_pressed", $PanelContainer, "_on_rename_parameter_selected")
		
		spell.connect("spell_selected", self, "_on_spell_selected")


func _on_spell_started():
	$SpellPanel/SpellsList._on_spell_started()
	$PanelContainer._on_spell_started()


func _on_spell_done():
	$SpellPanel/SpellsList._on_spell_done()


func _on_spell_selected(spell):
	emit_signal("spell_selected", spell.spell_id)

extends Control

var spellContainer = preload("res://ui/hud/sandbox/SpellContainer.tscn")
signal spell_selected(function_id)
signal player_ready(spells)

var _spell_ids_list = [
	GlobalConstants.SpellIds.MOVE_TO,
	GlobalConstants.SpellIds.USE_ELEVATOR,
	GlobalConstants.SpellIds.PRESS_ROUND_BUTTON,
	GlobalConstants.SpellIds.PRESS_SQUARE_BUTTON,
	GlobalConstants.SpellIds.TOGGLE_GATE,
	GlobalConstants.SpellIds.DESTROY_SUMMON,
	GlobalConstants.SpellIds.SUMMON_ASCENDING_PORTAL,
]
var _spells = []
var _active_spell_container: SpellContainer = null


func setup(spells):
	_spells = spells
	for spell in spells:
		var spell_container: SpellContainer = spellContainer.instance()
		spell_container.setup(spell)

		spell_container.connect(
			"spell_selected",
			$SpellPanel/VBoxContainer/ScrollContainer/SpellsList,
			"_on_spell_selected"
		)
		spell_container.connect(
			"spell_container_button_pressed",
			$SpellPanel/VBoxContainer/ScrollContainer/SpellsList,
			"_on_spell_container_button_pressed"
		)

		spell_container.connect(
			"spell_container_button_pressed",
			$SelectedSpellPanelContainer,
			"_on_spell_container_button_pressed"
		)
		spell_container.connect(
			"spell_container_rename_function_pressed",
			$SelectedSpellPanelContainer,
			"_on_rename_function_selected"
		)
		spell_container.connect(
			"spell_container_rename_parameter_pressed",
			$SelectedSpellPanelContainer,
			"_on_rename_parameter_selected"
		)

		spell_container.connect("spell_selected", self, "_on_spell_selected")

		$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.add_child(spell_container)


func on_spell_started(_spell_id):
	$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.disable_buttons()
	$SelectedSpellPanelContainer.hide()


func on_spell_done(succeded = true):
	if not succeded:
		var spell_name = (
			_active_spell_container.spell.spell_name.function_name
			if _active_spell_container
			else ""
		)
		$SelectedSpellPanelContainer.display_failed_spell_message(spell_name)

	$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.enable_buttons()


func _on_spell_selected(spell_container: SpellContainer):
	_active_spell_container = spell_container
	if spell_container:
		emit_signal("spell_selected", spell_container.spell.spell_id)
	else:
		emit_signal("spell_selected", null)


func _on_ReadyButton_toggled(button_pressed: bool):
	if button_pressed:
		$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.disable_buttons()
		emit_signal("player_ready", _spells)
	else:
		$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.enable_buttons()
		emit_signal("player_ready", null)

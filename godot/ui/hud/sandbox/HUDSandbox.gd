extends Control

var spellContainer = preload("res://ui/hud/sandbox/SpellContainer.tscn")
signal spell_selected(function_id)
signal player_ready(spells)

var _spells = []
var _active_spell: SpellDTO = null


func setup(spells, puzzle_mode: bool = false):
	if puzzle_mode:
		$SelectedSpellPanelContainer/SelectedSpell.set_text("Coloque os feitiços na lista")
	_setup_spells_list(spells, puzzle_mode)


func update_spells_queue(spells_queue):
	_spells = spells_queue


func _setup_spells_list(spells, puzzle_mode: bool = false):
	var spells_list = $SpellPanel/VBoxContainer/ScrollContainer/SpellsList
	if not puzzle_mode:
		_spells = spells
	for container in spells_list.get_children():
		spells_list.remove_child(container)
		container.queue_free()

	for spell in spells:
		var spell_container: SpellContainer = spellContainer.instance()
		spell_container.setup(spell, puzzle_mode)

		spell_container.connect("spell_selected", spells_list, "_on_spell_selected")
		spell_container.connect(
			"spell_container_button_pressed", spells_list, "_on_spell_container_button_pressed"
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

		spells_list.add_child(spell_container)


func on_spell_started(_spell_id):
	$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.disable_buttons()
	$SelectedSpellPanelContainer.hide()


func on_spell_done(succeded = true):
	if not succeded:
		var spell_name = _active_spell.spell_name.function_name if _active_spell else ""
		$SelectedSpellPanelContainer.display_failed_spell_message(spell_name)

	$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.enable_buttons()


func _on_spell_selected(spell: SpellDTO):
	_active_spell = spell
	if spell:
		emit_signal("spell_selected", spell.spell_id)
	else:
		emit_signal("spell_selected", null)


func _on_ReadyButton_toggled(button_pressed: bool):
	if button_pressed:
		$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.disable_buttons()
		emit_signal("player_ready", _spells)
	else:
		$SpellPanel/VBoxContainer/ScrollContainer/SpellsList.enable_buttons()
		emit_signal("player_ready", null)

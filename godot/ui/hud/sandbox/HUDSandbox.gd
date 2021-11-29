extends Control

var spellContainer = preload("res://ui/hud/sandbox/SpellContainer.tscn")
signal spell_selected(function_id)
signal player_ready(spells)

var _spells = []
var _active_spell: SpellDTO = null
var _puzzle_mode: bool = false
onready var _spells_list = get_node(
	"HamburgerContainer/SpellPanel/VBoxContainer/ScrollContainer/SpellsList"
)
onready var _spells_queue = get_node("SpellPanel/VBoxContainer/ScrollContainer/SpellsList")


func setup(spells, puzzle_mode: bool = false):
#	_puzzle_mode = true
	if _puzzle_mode:
		$SelectedSpellPanelContainer/SelectedSpell.set_text("Coloque os feitiços na lista")
		$SpellPanel/VBoxContainer/ReadyButton.hide()
	_setup_spells_list(spells)


func update_spells_queue(spells_queue):
	_spells = spells_queue


func _setup_spells_list(spells):
	if not _puzzle_mode:
		_spells = spells
	for container in _spells_list.get_children():
		_spells_list.remove_child(container)
		container.queue_free()

	for spell in spells:
		var spell_container: SpellContainer = spellContainer.instance()
		spell_container.setup(spell, _puzzle_mode)

		spell_container.connect("spell_selected", _spells_list, "_on_spell_selected")
		spell_container.connect(
			"spell_container_button_pressed", _spells_list, "_on_spell_container_button_pressed"
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

		_spells_list.add_child(spell_container)


func on_spell_started(_spell_id):
	_spells_list.disable_buttons()
	$SelectedSpellPanelContainer.hide()


func on_spell_done(succeded = true):
	if not succeded:
		var spell_name = _active_spell.spell_name.function_name if _active_spell else ""
		$SelectedSpellPanelContainer.display_failed_spell_message(spell_name)

	_spells_list.enable_buttons()


func _on_spell_selected(spell: SpellDTO):
	_active_spell = spell
	if spell:
		emit_signal("spell_selected", spell.spell_id)
	else:
		emit_signal("spell_selected", null)


func _on_ReadyButton_toggled(button_pressed: bool):
	if button_pressed:
		_spells_list.disable_buttons()
		emit_signal("player_ready", _spells)
	else:
		_spells_list.enable_buttons()
		emit_signal("player_ready", null)

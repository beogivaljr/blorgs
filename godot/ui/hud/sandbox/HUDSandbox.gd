extends Control

var spellContainer = preload("res://ui/hud/sandbox/SpellContainer.tscn")
signal spell_selected(function_id)
signal player_ready(spells)
signal sandbox_vote_updated(vote)
signal pass_turn
signal undo_pressed

var _spells = []
var _spell_queue = []
var _active_spell: SpellDTO = null
var _puzzle_mode: bool = false
var _your_turn = null
onready var _spells_list = get_node(
	"HamburgerContainer/SpellPanel/VBoxContainer/ScrollContainer/SpellsList"
)
onready var _spells_queue = get_node("SpellPanel/VBoxContainer/ScrollContainer/SpellsList")


func setup(spells, puzzle_mode: bool = false):
	_puzzle_mode = puzzle_mode
	if _puzzle_mode:
		$SelectedSpellPanelContainer/SelectedSpell.set_text("Coloque os feitiços na lista")
		$SpellPanel/VBoxContainer/ReadyButton.hide()
	else:
		$SpellPanel.hide()
		$HamburgerContainer/SpellPanel/VBoxContainer/SandboxButton.hide()
		$HamburgerContainer/SpellPanel/VBoxContainer/UndoButton.hide()
		$HamburgerContainer/SpellPanel/VBoxContainer/TurnButton.hide()
	_update_spells_list(spells)


func update_spells_queue(spell_queue):
	_spell_queue = spell_queue

	for container in _spells_queue.get_children():
		_spells_queue.remove_child(container)
		container.queue_free()

	for spell in spell_queue:
		var spell_container: SpellContainer = spellContainer.instance()
		spell_container.setup(spell, _puzzle_mode, true)

		spell_container.connect("spell_selected", _spells_queue, "_on_spell_selected")

		spell_container.connect("spell_selected", self, "_on_spell_selected")

		_spells_queue.add_child(spell_container)
	if spell_queue.empty() or spell_queue[-1].spell_call.character_type != GameState.character_type:
		on_disable_undo(true)
	elif spell_queue[-1].spell_call.character_type == GameState.character_type:
		on_disable_undo(false)


func _update_spells_list(spells):
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


func set_your_turn(your_turn):
	_your_turn = your_turn
	if your_turn:
		_spells_list.enable_buttons()
		$HamburgerContainer/SpellPanel/VBoxContainer/TurnButton.disabled = false
	else:
		$HamburgerContainer/SpellPanel/VBoxContainer/TurnButton.disabled = true
		_spells_list.disable_buttons()
		$SelectedSpellPanelContainer.hide()


func on_spell_started(_spell_id: int):
	_spells_list.disable_buttons()
	$HamburgerContainer/SpellPanel/VBoxContainer/ReadyButton.disabled = true
	$SelectedSpellPanelContainer.hide()


func on_spell_done(succeded: bool = true):
	if not succeded:
		var spell_name = _active_spell.spell_name.function_name if _active_spell else ""
		$SelectedSpellPanelContainer.display_failed_spell_message(spell_name)
	$HamburgerContainer/SpellPanel/VBoxContainer/ReadyButton.disabled = false
	_spells_list.enable_buttons()


func _on_spell_selected(spell: SpellDTO):
	_active_spell = spell
	if spell:
		emit_signal("spell_selected", _active_spell.spell_id)
	else:
		emit_signal("spell_selected", null)


func _on_ReadyButton_toggled(button_pressed: bool):
	if button_pressed:
#		$HamburgerContainer/SpellPanel/VBoxContainer/SandboxButton.pressed = false
#		_on_SandboxButton_toggled(false)
#		_spells_list.disable_buttons()
		_on_TurnButton_pressed()
		emit_signal("player_ready", _spells)
	else:
#		if _your_turn or not _puzzle_mode:
#			_spells_list.enable_buttons()
		emit_signal("player_ready", null)


func _on_UndoButton_pressed():
	on_disable_undo(true)
	emit_signal("undo_pressed")


func on_disable_undo(disable: bool):
	var should_disable = disable or not _your_turn
	$HamburgerContainer/SpellPanel/VBoxContainer/UndoButton.disabled = should_disable


#func _on_SandboxButton_toggled(button_pressed):
#	if button_pressed:
#		$HamburgerContainer/SpellPanel/VBoxContainer/ReadyButton.pressed = false
#		_on_ReadyButton_toggled(false)
#	emit_signal("sandbox_vote_updated", button_pressed)


func _on_TurnButton_pressed():
	set_your_turn(false)
	on_disable_undo(true)
	emit_signal("pass_turn")


func on_received_other_player_ready(ready):
	$HamburgerContainer/SpellPanel/VBoxContainer/TurnButton.disabled = ready

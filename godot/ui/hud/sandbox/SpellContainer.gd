class_name SpellContainer
extends PanelContainer

signal spell_selected(new_spell)
signal spell_container_rename_function_pressed(new_spell)
signal spell_container_rename_parameter_pressed(new_spell)
signal spell_container_button_pressed(button)

var _spell: SpellDTO


func setup(spell: SpellDTO, puzzle_mode: bool = false, queue: bool = false):
	var player_a_color = "ff7878"
	var player_b_color = "6f96ff"
	_spell = spell
	if GameState.character_type== GameState.CharacterTypes.A:
		$VBoxContainer/SpellName.add_color_override("font_color", Color(player_a_color))
	else:
		$VBoxContainer/SpellName.add_color_override("font_color", Color(player_b_color))
	if puzzle_mode:
		$VBoxContainer/HBoxContainer/RenameFnButton.visible = false
		$VBoxContainer/HBoxContainer/RenameParamButton.visible = false
		$VBoxContainer/HBoxContainer/SelectButton.set_text("Adicionar à lista")
		if queue:
			$VBoxContainer/HBoxContainer/SelectButton.visible = false
			if spell.spell_call.character_type == GameState.CharacterTypes.A:
				$VBoxContainer/SpellName.add_color_override("font_color", Color(player_a_color))
			else:
				$VBoxContainer/SpellName.add_color_override("font_color", Color(player_b_color))
	else:
		$VBoxContainer/HBoxContainer/RenameFnButton.button_name = _spell.spell_name.function_name

		if spell.spell_id == GlobalConstants.SpellIds.DESTROY_SUMMON:
			$VBoxContainer/HBoxContainer/RenameParamButton.visible = false
			_spell.spell_name.parameter_name = ""
		else:
			$VBoxContainer/HBoxContainer/RenameParamButton.button_name = _spell.spell_name.parameter_name
	_update_spell_name()

func toggle_enable_other_buttons(button: Button):
	if button.pressed:
		disable_other_buttons(button)
	else:
		enable_buttons()


func disable_other_buttons(selected_button: Button):
	for button in $VBoxContainer/HBoxContainer.get_children():
		if not button == selected_button and button is Button:
			button.pressed = false
			button.disabled = true


func enable_buttons():
	for button in $VBoxContainer/HBoxContainer.get_children():
		if button is Button:
			button.disabled = false


func _on_SelectButton_pressed():
	var button = $VBoxContainer/HBoxContainer/SelectButton
	if button.pressed:
		emit_signal("spell_selected", _spell)
	else:
		emit_signal("spell_selected", null)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/SelectButton)


func _on_RenameFnButton_pressed(new_name = null):
	if new_name:
		_spell.spell_name.function_name = new_name
		_update_spell_name()
	emit_signal("spell_container_rename_function_pressed", _spell)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameFnButton)


func _on_RenameParamButton_pressed(new_name = null):
	if new_name:
		_spell.spell_name.parameter_name = new_name
		_update_spell_name()
	emit_signal("spell_container_rename_parameter_pressed", _spell)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameParamButton)


func _update_spell_name():
	$VBoxContainer/SpellName.set_text(_spell.spell_name.function_name + "(" + _spell.spell_name.parameter_name + ")")

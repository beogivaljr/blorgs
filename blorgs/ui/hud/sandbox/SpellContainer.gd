class_name SpellContainer
extends PanelContainer

signal spell_selected(new_spell)
signal spell_container_rename_function_pressed(new_spell)
signal spell_container_rename_parameter_pressed(new_spell)
signal spell_container_button_pressed(button)

var spell


func setup(spell):
	self.spell = spell
	$VBoxContainer/HBoxContainer/RenameFnButton.button_name = self.spell.spell_name.function_name
	
	if spell.spell_id == GlobalConstants.SpellIds.DESTROY_SUMMON:
		$VBoxContainer/HBoxContainer/RenameParamButton.visible = false
		self.spell.spell_name.parameter_name = ""
	else:
		$VBoxContainer/HBoxContainer/RenameParamButton.button_name = self.spell.spell_name.parameter_name
	_update_spell_name()

func toggle_enable_other_buttons(button):
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
		emit_signal("spell_selected", self)
	else:
		emit_signal("spell_selected", null)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/SelectButton)


func _on_RenameFnButton_pressed(new_name = null):
	if new_name:
		spell.spell_name.function_name = new_name
		_update_spell_name()
	emit_signal("spell_container_rename_function_pressed", self)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameFnButton)


func _on_RenameParamButton_pressed(new_name = null):
	if new_name:
		spell.spell_name.parameter_name = new_name
		_update_spell_name()
	emit_signal("spell_container_rename_parameter_pressed", self)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameParamButton)


func _update_spell_name():
	$VBoxContainer/SpellName.set_text(spell.spell_name.function_name + "(" + spell.spell_name.parameter_name + ")")

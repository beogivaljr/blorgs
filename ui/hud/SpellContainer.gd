class_name SpellContainer
extends PanelContainer

signal spell_selected(new_spell)
signal spell_container_rename_function_pressed(new_spell)
signal spell_container_rename_parameter_pressed(new_spell)
signal spell_container_button_pressed(button)
signal spell_renamed


export(GlobalConstants.SpellIds) var spell_id = GlobalConstants.SpellIds.MOVE_TO
export var _function_name = GlobalConstants.RANDOM_NAMES[0]
export var _parameter_name = GlobalConstants.RANDOM_NAMES[1]
var spell_name = {
	function_name = _function_name,
	parameter_name = _parameter_name,
}



func _enter_tree():
	randomize()
	_function_name = GlobalConstants.RANDOM_NAMES[randi() % GlobalConstants.RANDOM_NAMES.size()]
	$VBoxContainer/HBoxContainer/RenameFnButton.button_name = _function_name
	
	if spell_id == GlobalConstants.SpellIds.DESTROY_SUMMON:
		$VBoxContainer/HBoxContainer/RenameParamButton.visible = false
		_parameter_name = ""
	else:
		_parameter_name = GlobalConstants.RANDOM_NAMES[randi() % GlobalConstants.RANDOM_NAMES.size()]
		$VBoxContainer/HBoxContainer/RenameParamButton.button_name = _parameter_name
	
	_update_spell_name()


func toggle_enable_other_buttons(button):
	if button.pressed:
		disable_other_buttons(button)
	else:
		enable_buttons()


func disable_other_buttons(selected_button):
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
		_function_name = new_name
		_update_spell_name()
	emit_signal("spell_container_rename_function_pressed", self)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameFnButton)


func _on_RenameParamButton_pressed(new_name = null):
	if new_name:
		_parameter_name = new_name
		_update_spell_name()
	emit_signal("spell_container_rename_parameter_pressed", self)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameParamButton)


func _update_spell_name():
	spell_name.function_name = _function_name
	spell_name.parameter_name = _parameter_name
	$VBoxContainer/SpellName.set_text(_function_name + "(" + _parameter_name + ")")

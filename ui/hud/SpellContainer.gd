extends PanelContainer

signal spell_selected(new_spell)
signal spell_container_button_pressed(button)
signal spell_renamed
signal function_done

export var function_name = "Blorgs"
export var parameter_name = "pindos"
var spell_name = [function_name, parameter_name]

export(GlobalConstants.SpellIds) var spell_id = GlobalConstants.SpellIds.MOVE_TO


func _on_any_button_pressed(button):
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
	emit_signal("spell_selected", self)
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/SelectButton)


func _on_RenameFnButton_pressed():
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameFnButton)


func _on_RenameParamButton_pressed():
	emit_signal("spell_container_button_pressed", $VBoxContainer/HBoxContainer/RenameParamButton)

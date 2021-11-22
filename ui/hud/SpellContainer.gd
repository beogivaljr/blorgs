extends PanelContainer

signal spell_selected(new_spell)
signal spell_renamed(new_spell)
signal function_done

export var function_name = "Blorgs"
export var parameter_name = ""
var spell_name = [function_name, parameter_name]


func deselect():
	$VBoxContainer/HBoxContainer/SelectButton.pressed = false


func disable_buttons():
	for button in $VBoxContainer/HBoxContainer.get_children():
		button.disabled = true


func enable_buttons():
	for button in $VBoxContainer/HBoxContainer.get_children():
		button.disabled = false


func _on_SelectButton_pressed():
	emit_signal("spell_selected", self)

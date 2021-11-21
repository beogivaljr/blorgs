extends HBoxContainer

signal spell_clicked(new_spell)
signal spell_renamed(spell)

export var spell_name = "Blorgs"


func _ready():
	$SelectButton.text = spell_name
	$SelectButton/LineEdit.text = spell_name


func deselect():
	$SelectButton.pressed = false


func _on_SelectButton_toggled(button_pressed):
	emit_signal("spell_clicked", self)


func _on_LineEdit_text_entered(new_text):
	spell_name = new_text
	emit_signal("spell_renamed", self)


func _on_SelectButton_pressed():
	emit_signal("spell_clicked", self)

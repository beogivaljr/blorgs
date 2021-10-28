extends Button


func _ready():
	pass


func _on_Button1_pressed():
	text = "Magia 1"
	show()


func _on_Button2_pressed():
	text = "Magia 2"
	show()


func _on_SelectedSpell_pressed():
	hide()

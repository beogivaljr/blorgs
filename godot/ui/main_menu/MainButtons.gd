extends VBoxContainer


signal new_game
signal connect_to_game


func _on_NewGame_pressed():
	emit_signal("new_game")


func _on_ConnectToGame_pressed():
	emit_signal("connect_to_game")

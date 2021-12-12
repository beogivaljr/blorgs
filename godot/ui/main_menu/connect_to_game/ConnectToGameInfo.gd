extends VBoxContainer

signal play_pressed(code)
signal connection_canceled


func _on_PlayButton_pressed() -> void:
	var game_code = $GameCodeLineEdit.text.to_upper()
	emit_signal("play_pressed", game_code)


func _on_ConnectToGameInfo_visibility_changed():
	if visible:
		var clipboard = OS.clipboard as String
		if clipboard.length() == 8:
			var message = "Encontramos algo que parece com um código de jogo\n"
			message += " em sua área de transferência. Gostaria de \ncolá-lo automaticamente?"
			var alert = GlobalConstants.alert(message, true)
			alert.connect("ok_pressed", self, "_paste_clipboard_code", [clipboard])


func _paste_clipboard_code(code):
	$GameCodeLineEdit.text = code


func _on_CancelButton_pressed():
	emit_signal("connection_canceled")

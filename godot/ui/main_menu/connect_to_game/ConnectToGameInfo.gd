extends VBoxContainer

signal play_pressed(code, playerName)


func _on_PlayButton_pressed() -> void:
	GameState.character_type = GameState.CharacterTypes.B
	var game_code = $GameCodeLineEdit.text
	var player_name = $PlayerName.text
	yield(ServerConnection.authenticate_async("Jogador2"), "completed")
	yield(ServerConnection.connect_to_server_async(), "completed")
	emit_signal("play_pressed", game_code, player_name)

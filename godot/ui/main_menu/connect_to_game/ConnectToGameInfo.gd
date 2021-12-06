extends VBoxContainer

signal play_pressed(code, playerName)


func _on_PlayButton_pressed() -> void:
	randomize()
	GameState.character_type = GlobalConstants.CharacterTypes.B
	var game_code = $GameCodeLineEdit.text
	var player_name = $PlayerName.text
	var user_name = String(rand_range(1, 999999)) + String(GameState.character_type)
	yield(ServerConnection.authenticate_async(user_name), "completed")
	yield(ServerConnection.connect_to_server_async(), "completed")
	emit_signal("play_pressed", game_code, player_name)

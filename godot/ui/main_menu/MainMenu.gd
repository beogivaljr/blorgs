extends Control

enum { MAIN_BUTTONS, NEW_GAME_INFO, CONNECT_TO_GAME_INFO, CONNECTING }


func _on_MainButtons_connect_to_game():
	_set_screen(CONNECT_TO_GAME_INFO)


func _on_MainButtons_new_game():
	GameState.player_type = GameState.PlayerTypes.A
	yield(ServerConnection.authenticate_async("Jogador1"), "completed")
	yield(ServerConnection.connect_to_server_async(), "completed")
	var match_code = yield(ServerConnection.create_match_async(), "completed")
	$ScreensContainer/NewGameInfo.set_game_code(match_code)
	print(match_code)
	yield(ServerConnection.join_match_async(match_code), "completed")
	ServerConnection.connect("player_list_updated", self, "_on_player_list_updated")
	_set_screen(NEW_GAME_INFO)


func _on_player_list_updated():
	get_tree().change_scene("res://levels/LevelManager.tscn")


func _on_NewGameInfo_on_cancelled() -> void:
	_set_screen(MAIN_BUTTONS)


func _on_ConnectToGameInfo_play_pressed(code, playerName) -> void:
	print("TODO: Connect to game with code: " + code + "\nAnd player name: " + playerName)
	_set_screen(CONNECTING)


func _set_screen(screen):
	for child in $ScreensContainer.get_children():
		child.visible = false

	match screen:
		MAIN_BUTTONS:
			$ScreensContainer/MainButtons.visible = true
		NEW_GAME_INFO:
			$ScreensContainer/NewGameInfo.visible = true
		CONNECT_TO_GAME_INFO:
			$ScreensContainer/ConnectToGameInfo.visible = true
		CONNECTING:
			$ScreensContainer/ConnectToGameInfo.visible = false


func _on_Connecting_canceled() -> void:
	print("TODO: Cancel game connection")
	_set_screen(MAIN_BUTTONS)

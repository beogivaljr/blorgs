extends Control

enum { MAIN_BUTTONS, NEW_GAME_INFO, CONNECT_TO_GAME_INFO, CONNECTING }


func _on_MainButtons_connect_to_game():
	_set_screen(CONNECT_TO_GAME_INFO)


func _on_MainButtons_new_game():
	## TODO: Move server/client game conection and creation out of the ScreenContainer
	yield(ServerConnection.authenticate_async("Jogador"), "completed")
	yield(ServerConnection.connect_to_server_async(), "completed")
	var hash_code = yield(ServerConnection.create_world_async(), "completed")
	print(hash_code)
	yield(ServerConnection.join_world_async(hash_code), "completed")
	$ScreensContainer/NewGameInfo.set_hash_code(hash_code)
	$ScreensContainer/NewGameInfo.create_new_game()
	get_tree().change_scene("res://levels/LevelManager.tscn")
	_set_screen(NEW_GAME_INFO)


func _on_NewGameInfo_on_cancelled() -> void:
	_set_screen(MAIN_BUTTONS)


func _on_ConnectToGameInfo_play_pressed(code, playerName) -> void:
	print("TODO: Connect to game with code: " + code + "\nAnd player name: " + playerName)
	_set_screen(CONNECTING)


func _set_screen(screen):
	match screen:
		MAIN_BUTTONS:
			$ScreensContainer/MainButtons.visible = true
			$ScreensContainer/NewGameInfo.visible = false
			$ScreensContainer/ConnectToGameInfo.visible = false
			$ScreensContainer/Connecting.visible = false
		NEW_GAME_INFO:
			$ScreensContainer/MainButtons.visible = false
			$ScreensContainer/NewGameInfo.visible = true
			$ScreensContainer/ConnectToGameInfo.visible = false
			$ScreensContainer/Connecting.visible = false
		CONNECT_TO_GAME_INFO:
			$ScreensContainer/MainButtons.visible = false
			$ScreensContainer/NewGameInfo.visible = false
			$ScreensContainer/ConnectToGameInfo.visible = true
			$ScreensContainer/Connecting.visible = false
		CONNECTING:
			$ScreensContainer/MainButtons.visible = false
			$ScreensContainer/NewGameInfo.visible = false
			$ScreensContainer/ConnectToGameInfo.visible = false
			$ScreensContainer/Connecting.visible = true


func _on_Connecting_canceled() -> void:
	print("TODO: Cancel game connection")
	_set_screen(MAIN_BUTTONS)

extends Control

enum { MAIN_BUTTONS, NEW_GAME_INFO, CONNECT_TO_GAME_INFO, CONNECTING }


func _ready():
	assert(ServerConnection.connect("player_list_updated", self, "_on_player_list_updated") == OK)
	if not ServerConnection.is_connected("all_spells_updated", GameState, "on_all_spells_updated"):
		assert(ServerConnection.connect("all_spells_updated", GameState, "on_all_spells_updated") == OK)
		assert(ServerConnection.connect("player_spells_updated", GameState, "on_player_spells_updated") == OK)
		assert(ServerConnection.connect("player_list_updated", GameState, "on_player_list_updated") == OK)


func _on_MainButtons_connect_to_game():
	_set_screen(CONNECT_TO_GAME_INFO)


func _on_MainButtons_new_game():
	GameState.character_type = GlobalConstants.CharacterTypes.A
	randomize()
	var user_name = String(rand_range(1, 999999)) + String(GameState.character_type)
	var result = yield(ServerConnection.authenticate_async(user_name), "completed")
	if result == OK:
		yield(ServerConnection.connect_to_server_async(), "completed")
		var match_code = yield(ServerConnection.create_match_async(), "completed")
		$VBoxContainer/ScreensContainer/NewGameInfo.set_game_code(match_code)
		_join_match(match_code)
		_set_screen(NEW_GAME_INFO)
	elif OS.is_debug_build():
		_on_player_list_updated(1)


func _on_player_list_updated(_player_count):
	assert(get_tree().change_scene("res://levels/LevelManager.tscn") == OK)


func _join_match(match_code):
	var presences = yield(ServerConnection.join_match_async(match_code), "completed")
	if presences == null:
		var title = "A conexão falhou!"
		var message = "Verifique se o código está correto e se o seu aparelho\n"
		message += " está conectado a internet, em seguida tente novamente."
		var alert = GlobalConstants.alert(title, message)
		alert.connect("popup_hide", self, "_on_Connecting_canceled")
		


func _on_NewGameInfo_canceled() -> void:
	_set_screen(MAIN_BUTTONS)


func _on_ConnectToGameInfo_play_pressed(match_code, _playerName) -> void:
	_join_match(match_code)
	_set_screen(CONNECTING)


func _set_screen(screen):
	for child in $VBoxContainer/ScreensContainer.get_children():
		child.visible = false

	match screen:
		MAIN_BUTTONS:
			$VBoxContainer/ScreensContainer/MainButtons.visible = true
		NEW_GAME_INFO:
			$VBoxContainer/ScreensContainer/NewGameInfo.visible = true
		CONNECT_TO_GAME_INFO:
			$VBoxContainer/ScreensContainer/ConnectToGameInfo.visible = true
		CONNECTING:
			$VBoxContainer/ScreensContainer/Connecting.visible = true


func _on_Connecting_canceled() -> void:
	_set_screen(MAIN_BUTTONS)

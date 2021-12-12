extends Control

enum { MAIN_BUTTONS, NEW_GAME_INFO, CONNECT_TO_GAME_INFO, CONNECTING }

var _device_id_salt: String = ""

func _ready():
	_bind_server_with_game_State()
	# Signal that will trigger the start of the game
	assert(ServerConnection.connect("player_list_updated", self, "_on_player_list_updated") == OK)
	_authenticate_and_start()
	return


func _bind_server_with_game_State():
	var Server = ServerConnection
	var Game = GameState
	if not Server.is_connected("all_spells_updated", Game, "on_all_spells_updated"):
		assert(Server.connect("all_spells_updated", Game, "on_all_spells_updated") == OK)
		assert(Server.connect("player_spells_updated", Game, "on_player_spells_updated") == OK)
		assert(Server.connect("player_list_updated", Game, "on_player_list_updated") == OK)


func _authenticate_and_start():
	var authentication_result = yield(_authenticate_async(), "completed")
	if authentication_result is NakamaException:
		_failed_to_authenticate(authentication_result)
		return
	_set_screen(MAIN_BUTTONS)


func _authenticate_async():
	var device_id = OS.get_unique_id() + _device_id_salt
	if device_id.empty():
		randomize()
		device_id = String(rand_range(1, 999999)) 
	return yield(ServerConnection.authenticate_async(device_id), "completed")


func _on_MainButtons_new_game():
	var connection_result = yield(_connect_to_server_async(), "completed")
	if connection_result is NakamaException:
		_failed_to_connect(connection_result)
		return
	var match_code = yield(ServerConnection.create_match_async(), "completed")
	if match_code is NakamaException:
		_failed_to_create_match(match_code)
		return
	var match_join_result = yield(ServerConnection.join_match_async(), "completed")
	if match_join_result is NakamaException:
		_failed_to_join_match(match_join_result)
		return
	$VBoxContainer/ScreensContainer/NewGameInfo.set_game_code(match_code)
	_set_screen(NEW_GAME_INFO)


func _on_MainButtons_connect_to_game():
	var connection_result = yield(_connect_to_server_async(), "completed")
	if connection_result is NakamaException:
		_failed_to_connect(connection_result)
		return
	_set_screen(CONNECT_TO_GAME_INFO)


func _connect_to_server_async():
	GameState.character_type = GlobalConstants.CharacterTypes.NONE
	return yield(ServerConnection.connect_to_server_async(), "completed")


func _on_player_list_updated(player_count):
	if GameState.character_type == GlobalConstants.CharacterTypes.NONE:
		if player_count == 1:
			GameState.character_type = GlobalConstants.CharacterTypes.A
		elif player_count == 2:
			GameState.character_type = GlobalConstants.CharacterTypes.B
	if player_count == 2:
		assert(get_tree().change_scene("res://levels/LevelManager.tscn") == OK)
	elif player_count > 2: 
		var message = "Partida cheia!\nSó é possível jogar no máximo com dois\n"
		message += "jogadores por vez."
		GlobalConstants.alert(message)
		ServerConnection.disconnect_from_server()


func _on_ConnectToGameInfo_play_pressed(match_code) -> void:
	_set_screen(CONNECTING)
	var match_id_result = yield(ServerConnection.request_match_id_async(match_code), "completed")
	if match_id_result is NakamaException:
		yield(_failed_to_get_match_id(match_id_result), "completed")
		_set_screen(MAIN_BUTTONS)
		return
	var match_join_result = yield(ServerConnection.join_match_async(), "completed")
	if match_join_result is NakamaException:
		var exception_code = match_join_result.status_code
		if (
				OS.is_debug_build() 
				and exception_code == ServerConnection.Exceptions.USER_ALREADY_LOGGED_IN
		):
			_retry_debug(match_code, match_join_result)
			return
		yield(_failed_to_join_match(match_join_result), "completed")
		_set_screen(MAIN_BUTTONS)
		return


func _on_NewGameInfo_canceled() -> void:
	_set_screen(MAIN_BUTTONS)


func _on_Connecting_canceled() -> void:
	_set_screen(MAIN_BUTTONS)


func _on_ConnectToGameInfo_connection_canceled():
	_set_screen(MAIN_BUTTONS)


func _set_screen(screen):
	for child in $VBoxContainer/ScreensContainer.get_children():
		child.visible = false
	match screen:
		MAIN_BUTTONS:
			ServerConnection.disconnect_from_server()
			$VBoxContainer/ScreensContainer/MainButtons.visible = true
		NEW_GAME_INFO:
			$VBoxContainer/ScreensContainer/NewGameInfo.visible = true
		CONNECT_TO_GAME_INFO:
			$VBoxContainer/ScreensContainer/ConnectToGameInfo.visible = true
		CONNECTING:
			$VBoxContainer/ScreensContainer/Connecting.visible = true


func _failed_to_authenticate(exception: NakamaException):
	push_error(exception.to_string())
	var message = "Não foi possível autenticar.\n"
	message += "Tente novamente mais tarde ou entre em contato conosco."
	var alert = GlobalConstants.alert(message, false, "Tentar Novamente")
	yield(alert, "ok_pressed")
	_authenticate_and_start()


func _failed_to_connect(exception: NakamaException):
	push_error(exception.to_string())
	var message = "Não foi possível conectar com o servidor.\n"
	message += "Tente novamente mais tarde ou entre em contato conosco."
	var alert = GlobalConstants.alert(message, false, "Tentar Novamente")
	return yield(alert, "ok_pressed")


func _failed_to_create_match(exception: NakamaException):
	push_error(exception.to_string())
	var message = "Não foi possível criar uma partida.\n"
	message += "Tente novamente mais tarde ou entre em contato conosco."
	var alert = GlobalConstants.alert(message, false)
	return yield(alert, "ok_pressed")


func _failed_to_get_match_id(exception: NakamaException):
	push_error(exception.to_string())
	var message = "O código não foi encontrado ou o servidor não foi capaz de criar uma partida.\n"
	message += "Tente novamente mais tarde ou entre em contato conosco."
	var alert = GlobalConstants.alert(message, false)
	return yield(alert, "ok_pressed")


func _failed_to_join_match(exception: NakamaException):
	push_error(exception.to_string())
	var message = "Não foi possível juntar-se a partida.\n"
	message += "Tente novamente mais tarde ou entre em contato conosco."
	var alert = GlobalConstants.alert(message, false)
	return yield(alert, "ok_pressed")


func _retry_debug(match_code, match_join_result):
	randomize()
	if _device_id_salt != "":
		if int(_device_id_salt) > 5:
			yield(_failed_to_join_match(match_join_result), "completed")
			_set_screen(MAIN_BUTTONS)
			return
		_device_id_salt = String(int(_device_id_salt) + 1)
	else:
		_device_id_salt = "1"
	print_debug("Salted device with: " + _device_id_salt)
	yield(_authenticate_async(), "completed")
	yield(_connect_to_server_async(), "completed")
	_on_ConnectToGameInfo_play_pressed(match_code)

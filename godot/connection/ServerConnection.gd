extends Node

const KEY := "blorgs"

signal player_spells_updated(player_spells)
signal all_spells_updated(all_spells)
signal all_spell_calls_updated(spell_call_list)
signal received_start_simulation(spell_call_list)
signal player_list_updated

enum OpCodes { DO_SPAWN = 1, PLAYER_JOINED, PLAYER_SPELLS }

var _session: NakamaSession
var _client := Nakama.create_client(KEY, "127.0.0.1", 7350, "http")
var _socket: NakamaSocket
var _match_id := ""
var _presences := {}


func authenticate_async(username: String) -> int:
	var deviceid = OS.get_unique_id() + username
	var result := OK

	var new_session: NakamaSession = yield(
		_client.authenticate_device_async(deviceid, username, true), "completed"
	)
	if not new_session.is_exception():
		_session = new_session
	else:
		result = new_session.get_exception().status_code
	return result


func connect_to_server_async() -> int:
	_socket = Nakama.create_socket_from(_client)
	if _session:
		var result: NakamaAsyncResult = yield(_socket.connect_async(_session), "completed")
		if not result.is_exception():
			assert(_socket.connect("closed", self, "on_NakamaSocket_closed"))
			assert(_socket.connect("received_match_state", self, "_on_NakamaSocket_received_match_state"))
			return OK
	return ERR_CANT_CONNECT


func on_NakamaSocket_closed() -> void:
	_socket = null


func join_match_async(match_code: String) -> Dictionary:
	var match_id_response: NakamaAPI.ApiRpc = yield(
		_client.rpc_async(_session, "get_match_id", match_code), "completed"
	)
	if not match_id_response.is_exception():
		_match_id = match_id_response.payload

	# Request to join the match through the NakamaSocket API.
	var match_join_result: NakamaRTAPI.Match = yield(
		_socket.join_match_async(_match_id), "completed"
	)
	if match_join_result.is_exception():
		var exception: NakamaException = match_join_result.get_exception()
		printerr("Could not join the match: %s - %s" % [exception.status_code, exception.message])
		return {}

	for presence in match_join_result.presences:
		_presences[presence.user_id] = presence
	return _presences


func create_match_async() -> String:
	var response: NakamaAPI.ApiRpc = yield(
		_client.rpc_async(
			_session,
			"create_world",
			JSON.print(
				{
					user_spells = [
						GameState.get_dict_spells(GameState.CharacterTypes.A),
						GameState.get_dict_spells(GameState.CharacterTypes.B)
					]
				}
			)
		),
		"completed"
	)
	if not response.is_exception():
		var hash_code: String = response.payload
		return hash_code
	else:
		return "Error"


# Sends a message to the server stating the client is spawning in after character selection.
func send_spawn() -> void:
	if _socket:
		_socket.send_match_state_async(_match_id, OpCodes.DO_SPAWN, "")


func request_player_spells() -> void:
	if _socket:
		_socket.send_match_state_async(_match_id, OpCodes.PLAYER_SPELLS, "")


func request_all_spells() -> void:
	if _socket:
		push_error("TODO: impelment server function")
#		emit -> all_spells_updated(all_spells)
#		_socket.send_match_state_async(_match_id, OpCodes.PLAYER_SPELLS, "")


func request_all_spell_calls() -> void:
	if _socket:
#		emit -> all_spell_calls_updated(spell_call_list)
		push_error("TODO: impelment server function")


func request_start_simulation(spell_call_list) -> void:
	# Remove this loop back
	emit_signal("received_start_simulation", spell_call_list)
	if _socket:
#		emit -> received_start_simulation(spell_call_list)
		push_error("TODO: impelment server function")


# Called when the server received a custom message from the server.
func _on_NakamaSocket_received_match_state(match_state: NakamaRTAPI.MatchData) -> void:
	var code := match_state.op_code
	var raw := match_state.data

	match code:
		OpCodes.DO_SPAWN:
			var decoded: Dictionary = JSON.parse(raw).result
		OpCodes.PLAYER_JOINED:
			var decoded: int = JSON.parse(raw).result
			if decoded > 1:
				print("Other player just joined")
				emit_signal("player_list_updated")
		OpCodes.PLAYER_SPELLS:
			var decoded = JSON.parse(raw).result
			var spells = []
			for spell in decoded:
				spells.append(SpellDTO.new(spell))
			emit_signal("player_spells_updated", spells)

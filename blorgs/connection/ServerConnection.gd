extends Node

const KEY := "blorgs"

enum OpCodes { DO_SPAWN = 1 }

var _session: NakamaSession
var _client := Nakama.create_client(KEY, "127.0.0.1", 7350, "http")
var _socket: NakamaSocket
var _world_id := ""
var _presences := {}


func authenticate_async(username: String) -> int:
	var deviceid = OS.get_unique_id()
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
	var result: NakamaAsyncResult = yield(_socket.connect_async(_session), "completed")
	if not result.is_exception():
		_socket.connect("closed", self, "on_NakamaSocket_closed")
		return OK
	return ERR_CANT_CONNECT


func on_NakamaSocket_closed() -> void:
	_socket = null


func join_world_async(world_code: String) -> Dictionary:
	var world: NakamaAPI.ApiRpc = yield(
		_client.rpc_async(_session, "get_world_id", world_code), "completed"
	)
	if not world.is_exception():
		_world_id = world.payload

	# Request to join the match through the NakamaSocket API.
	var match_join_result: NakamaRTAPI.Match = yield(
		_socket.join_match_async(_world_id), "completed"
	)
	if match_join_result.is_exception():
		var exception: NakamaException = match_join_result.get_exception()
		printerr("Could not join the match: %s - %s" % [exception.status_code, exception.message])
		return {}

	for presence in match_join_result.presences:
		_presences[presence.user_id] = presence
	return _presences


func create_world_async() -> String:
	var response: NakamaAPI.ApiRpc = yield(_client.rpc_async(_session, "create_world"), "completed")
	if not response.is_exception():
		var hash_code: String = response.payload
		return hash_code
	else:
		return "Error"


# Sends a message to the server stating the client is spawning in after character selection.
func send_spawn(spells: Array) -> void:
	var payload = []
	for spell in spells:
		payload.append({spell_id = spell.spell_id, spell_name = spell.spell_name})

	if _socket:
		_socket.send_match_state_async(_world_id, OpCodes.DO_SPAWN, JSON.print(spells))

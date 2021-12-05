extends BaseLevel

onready var _spells_list_manager = preload("res://levels/maze/SpellsListManager.tscn").instance()


func _ready():
	# Geta all spells
	var spells = GameState.get_all_spells()
	
	# Setups
	_bind_server_signals()
	_setup_hud(_get_filtered_level_spells(spells))
	_setup_world()
	_setup_spells_list_manager()
	
	# Set starting player
	if _starting_player_type == GameState.character_type:
		_hud.set_your_turn(true)
	else:
		_hud.set_your_turn(false)


func _bind_server_signals():
	ServerConnection.connect("all_spell_calls_updated", _spells_list_manager, "on_spell_call_list_updated")
	ServerConnection.connect("your_turn_started", self, "_on_your_turn_started")
	ServerConnection.connect("received_start_simulation", _spells_list_manager, "start_simulation", [_world])
	ServerConnection.connect("received_other_player_ready", _hud, "on_received_other_player_ready")


func _setup_hud(spells):
	_hud.connect("player_ready", self, "_on_player_ready")
	_hud.connect("spell_selected", _world, "begin_casting_spell")
	_hud.connect("sandbox_vote_updated", self, "_on_sandbox_vote_updated")
	_hud.connect("undo_pressed", _spells_list_manager, "on_undo_pressed")
	_hud.connect("pass_turn", _spells_list_manager, "on_turn_passed")
	add_child(_hud) # _ready() before setup()
	_hud.setup(spells, true)


func _setup_world():
	_world._active_player_id = _starting_player_type
	_world.connect("valid_parameter_selected", _spells_list_manager, "on_spell_and_parameter_selected")
	add_child(_world)


func _setup_spells_list_manager():
	_spells_list_manager.connect("spell_started", _hud, "on_spell_started")
	_spells_list_manager.connect("spell_done", _hud, "on_spell_done")
	_spells_list_manager.connect("spell_list_updated", _hud, "update_spells_queue")
	_spells_list_manager.connect("started_autocasting_spell", _hud, "on_started_autocasting_spell")
	_spells_list_manager.connect("game_over", self, "_on_game_over")
	add_child(_spells_list_manager)


func _on_player_ready(spells):
	var ready = spells != null
	_spells_list_manager.send_ready_and_spell_call_list(ready)


func _on_your_turn_started(spell_call_list):
	_hud.set_your_turn(true)
	_spells_list_manager.on_spell_call_list_updated(spell_call_list)


func _on_game_over(won):
	get_tree().paused = true
	var game_over_popup = preload("res://ui/game_over/GameOverPopup.tscn").instance()
	call_deferred("add_child", game_over_popup)
	yield(game_over_popup, "ready")
	game_over_popup.setup(won)
	game_over_popup.next_level_button.connect("pressed", self, "_on_next_level_button_pressed", [], CONNECT_ONESHOT)
	game_over_popup.try_again_button.connect("pressed", self, "_on_try_again_button_pressed", [], CONNECT_ONESHOT)


func _on_next_level_button_pressed():
	get_tree().paused = false
	emit_signal("level_finished")


func _on_try_again_button_pressed():
	get_tree().paused = false
	emit_signal("level_failed")


#func _on_sandbox_vote_updated(vote):
#	push_error("TODO: call servet to say to go back to sandbox level.")
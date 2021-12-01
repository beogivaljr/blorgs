extends BaseLevel

onready var _spells_list_manager = preload("res://levels/maze/SpellsListManager.tscn").instance()


func _ready():
	# Geta all spells
#	ServerConnection.request_all_spells()
#	yield(GameState, "all_spells_updated")
	var spells = GameState.get_all_spells()
	
	# Setups
	_setup_hud(_get_filtered_level_spells(spells))
	_setup_world()
	_setup_spells_list_manager()


func _setup_hud(spells):
	_hud.connect("player_ready", self, "_on_player_ready")
	_hud.connect("spell_selected", _world, "begin_casting_spell")
	_hud.connect("sandbox_vote_updated", self, "_on_sandbox_vote_updated")
	_hud.connect("undo_pressed", _spells_list_manager, "on_undo_pressed")
	_hud.connect("pass_turn", _spells_list_manager, "on_turn_passed")
	add_child(_hud) # _ready() before setup()
	_hud.setup(spells, true)


func _setup_world():
	_world.connect("valid_parameter_selected", _spells_list_manager, "on_spell_and_parameter_selected")
	add_child(_world)


func _setup_spells_list_manager():
	_spells_list_manager.connect("spell_started", _hud, "on_spell_started")
	_spells_list_manager.connect("spell_done", _hud, "on_spell_done")
	_spells_list_manager.connect("spell_list_updated", _hud, "update_spells_queue")
	ServerConnection.connect("all_spell_calls_updated", _spells_list_manager, "on_spell_call_list_updated")
	ServerConnection.connect("your_turn_started", _spells_list_manager, "on_spell_call_list_updated")
	ServerConnection.connect("received_start_simulation", _spells_list_manager, "start_simulation", [_world])


func _on_player_ready(_spells):
	_spells_list_manager.send_ready_and_spell_call_list()


func _on_sandbox_vote_updated(vote):
	push_error("TODO: call servet to say to go back to sandbox level.")

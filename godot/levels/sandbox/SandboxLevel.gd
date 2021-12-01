extends BaseLevel

func _ready():
	var spells = GameState.get_spells()
	_setup_hud(_get_filtered_level_spells(spells))
	_setup_world()


func _setup_hud(spells):
	_hud.connect("player_ready", self, "_on_player_ready")
	_hud.connect("spell_selected", _world, "begin_casting_spell")
	add_child(_hud) # _ready() before setup()
	_hud.setup(spells)


func _setup_world():
	_world.connect("spell_started", _hud, "on_spell_started")
	_world.connect("spell_done", _hud, "on_spell_done")
	add_child(_world)


func _on_player_ready(spells):
	ServerConnection.send_spawn(spells)
	emit_signal("level_finished")

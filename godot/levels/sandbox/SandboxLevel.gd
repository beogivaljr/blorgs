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
	var ready = spells != null
	if ready:
		ServerConnection.send_spawn(_get_merged_spell_list(spells), ready)
		yield(ServerConnection, "all_spells_updated")
		emit_signal("level_finished")

func _get_merged_spell_list(filtered_spell_list):
	var full_spell_list = GameState.get_spells()
	for new_spell in filtered_spell_list:
		for old_spell in full_spell_list:
			if (old_spell as SpellDTO).spell_id == (new_spell as SpellDTO).spell_id:
				var list = (full_spell_list as Array)
				list.erase(old_spell)
				list.append(new_spell)
	return full_spell_list

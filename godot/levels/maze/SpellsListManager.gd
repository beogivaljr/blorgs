extends Node

signal spell_started(spell_id)
signal spell_done(succeded)
signal spell_list_updated(spell_list)
signal game_over(won)

var _spell_call_list = []

func _ready():
	pass


func on_spell_and_parameter_selected(spell_id, node_name, location):
	var new_spell = GameState.get_spell(GameState.character_type, spell_id, node_name, location)
	_spell_call_list.append(new_spell)
	emit_signal("spell_started", spell_id)
	call_deferred("emit_signal", "spell_done", true)
	on_spell_call_list_updated(_spell_call_list)


func on_spell_call_list_updated(spell_list):
	_spell_call_list = spell_list
	emit_signal("spell_list_updated", spell_list)


func send_ready_and_spell_call_list(ready):
	ServerConnection.send_ready_state(_spell_call_list, ready)


func start_simulation(spell_list, world: MazeWorld):
	if not spell_list.empty():
		var any_spell_id = GlobalConstants.SpellIds.MOVE_TO
		emit_signal("spell_started", any_spell_id)
		for spell in spell_list:
			var spell_dto = (spell as SpellDTO)
			var spell_id = spell_dto.spell_id
			var spell_call_dto = spell_dto.spell_call
			var player_id = spell_call_dto.character_type
			var node_name = spell_call_dto.target_parameter_node_name
			var location = spell_call_dto.target_parameter_location
			world.auto_cast_spell(player_id, spell_id, node_name, location)
			yield(world, "spell_done")
			yield(get_tree().create_timer(0.25), "timeout") # Small delay between spells
		if world.players_on_finish_line >= 2:
			_game_over(true)
			return
	_game_over(false)


func on_undo_pressed():
	_spell_call_list.pop_back()
	on_spell_call_list_updated(_spell_call_list)


func on_turn_passed():
	ServerConnection.send_pass_turn(_spell_call_list)


func _game_over(won):
	emit_signal("game_over", won)

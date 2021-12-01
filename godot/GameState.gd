extends Node

signal all_spells_updated

enum LevelIds {
	SANDBOX,
	MAZE1,
	MAZE2,
	MAZE3,
	MAZE4,
}

enum CharacterTypes { A, B, SA, SB }
var _spells_a
var _spells_b
const _SPELLS = GlobalConstants.SpellIds
var character_type


func on_player_list_updated():
	pass


func on_player_spells_updated(spells, p_player_type: int = character_type):
	match p_player_type:
		CharacterTypes.A:
			_spells_a = spells
		CharacterTypes.B:
			_spells_b = spells


func on_all_spells_updated(spells):
	_spells_a = spells[0]
	_spells_b = spells[1]
	emit_signal("all_spells_updated")


func _get_new_spell(spell_id: int) -> SpellDTO:
	randomize()
	var spell_name = {
		function_name = GlobalConstants.RANDOM_NAMES[randi() % GlobalConstants.RANDOM_NAMES.size()],
		parameter_name = GlobalConstants.RANDOM_NAMES[randi() % GlobalConstants.RANDOM_NAMES.size()]
	}
	var spell = SpellDTO.new({spell_id = spell_id, spell_name = spell_name})

	return spell


var current_level_id = LevelIds.SANDBOX
var current_maze_index = 0


func get_spells(p_player_type: int = character_type):
	randomize()
	match p_player_type:
		CharacterTypes.A:
			_spells_a = (
				_spells_a
				if _spells_a
				else [
					_get_new_spell(_SPELLS.USE_ELEVATOR),
					_get_new_spell(_SPELLS.PRESS_SQUARE_BUTTON),
					_get_new_spell(_SPELLS.TOGGLE_GATE),
					_get_new_spell(_SPELLS.PRESS_ROUND_BUTTON)
				]
			)

			_spells_a.shuffle()
			return _spells_a

		CharacterTypes.B:
			_spells_b = (
				_spells_b
				if _spells_b
				else [
					_get_new_spell(_SPELLS.MOVE_TO),
					_get_new_spell(_SPELLS.SUMMON_ASCENDING_PORTAL),
					_get_new_spell(_SPELLS.DESTROY_SUMMON),
					_get_new_spell(_SPELLS.SUMMON_DESCENDING_PORTAL)
				]
			)

			_spells_b.shuffle()
			return _spells_b


func get_all_spells():
	randomize()
	var spells = get_spells(CharacterTypes.A) as Array
	spells.append_array(get_spells(CharacterTypes.B))
#	spells.shuffle()
	push_warning("TODO: shuffle list.")
	return spells


func get_dict_spells(p_player_type: int):
	var player_spells = []
	for spell in get_spells(p_player_type):
		player_spells.append(spell.dict())
	return player_spells

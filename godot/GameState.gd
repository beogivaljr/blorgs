extends Node

signal all_spells_updated

var current_level_index = 0
enum CharacterTypes { NONE, A, B}
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
	var spell_call = {
		character_type = character_type,
		target_parameter_node_name = null,
		target_parameter_location = null,
	}
	var spell = SpellDTO.new({spell_id = spell_id, spell_name = spell_name, spell_call = spell_call})

	return spell


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
	spells.shuffle()
	return spells


func get_dict_spells(p_player_type: int):
	var player_spells = []
	for spell in get_spells(p_player_type):
		player_spells.append(spell.dict())
	return player_spells


func get_spell(character_id, spell_id, node_name, location):
	var all_spells = get_all_spells()
	for spell in all_spells:
		if spell.spell_id == spell_id:
			spell.spell_call.character_type = character_id
			spell.spell_call.target_parameter_node_name = node_name
			spell.spell_call.target_parameter_location = location
			return spell
	return null

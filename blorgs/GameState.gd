extends Node

enum LevelIds {
	SANDBOX,
	MAZE1,
	MAZE2,
	MAZE3,
	MAZE4,
}

var _spells setget , get_spells
const _SPELLS = GlobalConstants.SpellIds


func _get_new_spell(spell_id: int) -> SpellNameDTO:
	var spell = SpellDTO.new()
	spell.spell_id = spell_id

	spell.spell_name = SpellNameDTO.new()

	randomize()
	spell.spell_name.function_name = GlobalConstants.RANDOM_NAMES[(
		randi()
		% GlobalConstants.RANDOM_NAMES.size()
	)]
	spell.spell_name.parameter_name = GlobalConstants.RANDOM_NAMES[(
		randi()
		% GlobalConstants.RANDOM_NAMES.size()
	)]

	return spell


func _init():
	_spells = [
		_get_new_spell(_SPELLS.MOVE_TO),
		_get_new_spell(_SPELLS.TOGGLE_GATE),
		_get_new_spell(_SPELLS.USE_ELEVATOR)
	]


var current_level_id = LevelIds.SANDBOX
var current_maze_index = 0


# Add current function names here
func get_spells():
	randomize()
	_spells.shuffle()

	return _spells

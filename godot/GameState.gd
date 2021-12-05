extends Node

signal all_spells_updated

const _SPELLS = GlobalConstants.SpellIds
const _CHARACTER_TYPES = GlobalConstants.CharacterTypes

var current_level_index = 0
var _spells_a
var _spells_b
var character_type


func on_player_list_updated(player_count):
	if player_count < 2:
		var game_over_popup = load("res://ui/game_over/GameOverPopup.tscn").instance()
		get_tree().paused = true
		get_tree().root.call_deferred("add_child", game_over_popup)
		yield(game_over_popup, "ready")
		game_over_popup.setup(false)
		yield(game_over_popup.try_again_button, "pressed")
		game_over_popup.queue_free()
		self.clear()
		get_tree().paused = false
		get_tree().change_scene("res://Main.tscn")


func on_player_spells_updated(spells, p_player_type: int = character_type):
	match p_player_type:
		_CHARACTER_TYPES.A:
			_spells_a = spells
		_CHARACTER_TYPES.B:
			_spells_b = spells


func on_all_spells_updated(spells):
	_spells_a = spells[0]
	_spells_b = spells[1]
	emit_signal("all_spells_updated")


func _get_new_spell(spell_id: int) -> SpellDTO:
	randomize()
	var spell_name = SpellNameDTO.new()
	spell_name.function_name = GlobalConstants.RANDOM_NAMES[randi() % GlobalConstants.RANDOM_NAMES.size()]
	spell_name.parameter_name = GlobalConstants.RANDOM_NAMES[randi() % GlobalConstants.RANDOM_NAMES.size()]
	var spell_call = SpellCallDTO.new()
	spell_call.character_type = character_type
	var spell = SpellDTO.new()
	spell.spell_id = spell_id
	spell.spell_name = spell_name
	spell.spell_call = spell_call
	return spell


func get_spells(p_player_type: int = character_type):
	randomize()
	match p_player_type:
		_CHARACTER_TYPES.A:
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
			return _spells_a.duplicate()
		_CHARACTER_TYPES.B:
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
			return _spells_b.duplicate()


func get_all_spells():
	randomize()
	var spells = get_spells(_CHARACTER_TYPES.A) as Array
	spells.append_array(get_spells(_CHARACTER_TYPES.B))
	spells.shuffle()
	return spells


func get_spell(character_id, spell_id, node_name, location):
	var all_spells = get_all_spells()
	for spell in all_spells:
		if spell.spell_id == spell_id:
			spell.spell_call.character_type = character_id
			spell.spell_call.target_parameter_node_name = node_name
			spell.spell_call.target_parameter_location = location
			return spell
	return null

func clear():
	current_level_index = 0
	_spells_a = null
	_spells_b = null
	character_type = null

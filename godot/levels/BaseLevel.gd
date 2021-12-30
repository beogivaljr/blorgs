class_name BaseLevel
extends Node

signal level_finished
signal level_failed

export var _starting_player_type = GlobalConstants.CharacterTypes.NONE
export(PackedScene) var _packed_world_a
export(PackedScene) var _packed_world_b
export(Array, GlobalConstants.SpellIds) var _current_level_spells = []

onready var _world: BaseWorld = (
		_packed_world_a.instance() if (GameState.character_type == GlobalConstants.CharacterTypes.A)
		else _packed_world_b.instance() if (GameState.character_type == GlobalConstants.CharacterTypes.B)
		else null
	)
onready var _hud = preload("res://ui/hud/sandbox/HUDSandbox.tscn").instance()


func _get_filtered_level_spells(spells):
	var filtered_spells = []
	for spell in spells:
		var spell_dto = (spell as SpellDTO)
		if _current_level_spells.has(spell_dto.id):
			filtered_spells.append(spell)
	return filtered_spells

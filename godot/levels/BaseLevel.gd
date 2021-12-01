class_name BaseLevel
extends Node

signal level_finished

export(GameState.CharacterTypes) var _starting_player_type
export(PackedScene) var _packed_world
export(Array, GlobalConstants.SpellIds) var _current_level_spells = []

onready var _world: BaseWorld = _packed_world.instance()
onready var _hud = preload("res://ui/hud/sandbox/HUDSandbox.tscn").instance()

func _ready():
	pass


func _get_filtered_level_spells(spells):
	var filtered_spells = []
	for spell in spells:
		var spell_dto = (spell as SpellDTO)
		if _current_level_spells.has(spell_dto.spell_id):
			filtered_spells.append(spell)
	return filtered_spells

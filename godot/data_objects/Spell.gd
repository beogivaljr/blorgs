class_name SpellDTO
extends Node

var spell_id: int
var spell_name: SpellNameDTO


func _init(spell_dictionary: Dictionary):
	spell_id = spell_dictionary.spell_id
	spell_name = SpellNameDTO.new(spell_dictionary.spell_name)
	return self


func dict():
	return {spell_id = spell_id, spell_name = spell_name.dict()}

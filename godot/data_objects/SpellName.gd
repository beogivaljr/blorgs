class_name SpellNameDTO
extends Node

var function_name: String
var parameter_name: String


func _init(spell_name_dict: Dictionary):
	function_name = spell_name_dict.function_name
	parameter_name = spell_name_dict.parameter_name


func dict():
	return {function_name = function_name, parameter_name = parameter_name}

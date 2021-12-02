class_name SpellCallDTO
extends Node

var character_type: int
var target_parameter_node_name: String
var target_parameter_location: Vector3

func _init(spell_call_dictionary: Dictionary):
	if spell_call_dictionary.character_type:
		self.character_type = spell_call_dictionary.character_type
	if spell_call_dictionary.target_parameter_node_name:
		self.target_parameter_node_name = spell_call_dictionary.target_parameter_node_name
	var location = spell_call_dictionary.target_parameter_location
	if location:
		self.target_parameter_location = Vector3(location.x, location.y, location.z)
	return self


func dict():
	return {
		character_type = character_type,
		target_parameter_node_name = target_parameter_node_name, 
		target_parameter_location = {
			x = target_parameter_location.x,
			y = target_parameter_location.y,
			z = target_parameter_location.z,
			},
		}

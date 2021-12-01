class_name SpellCallDTO
extends Node

var character_type: int
var spell_id: int
var target_parameter_node_name: String
var target_parameter_location: Vector3

func _init(
	character_type: int,
	spell_id: int,
	target_parameter_node_name: String,
	target_parameter_location: Vector3
	):
	self.character_type = character_type
	self.spell_id = spell_id
	self.target_parameter_node_name = target_parameter_node_name
	self.target_parameter_location = target_parameter_location

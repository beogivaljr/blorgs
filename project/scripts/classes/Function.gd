extends Object
class_name Function, "res://icon.png"

"""
This class stores a custom high-level function created
by Player during Sandbox mode. Each custom function is
a list of instructions (Step) that are run imperatively.
"""

const DEFAULT_NAME = "New Function"
var name: String
var steps:= []


"""
Create a new Function by setting its name.
"""
func _init(name: String = DEFAULT_NAME) -> void:
	self.name = name


"""
Append new Step to Function.
"""
func append(new_step: Step) -> void:
	steps.append(new_step)


"""
Useful for JSON conversions.
"""
func dictionary() -> Dictionary:
	var dict = {
		"name": name,
		"steps": [],
	}
	for step in steps:
		dict.steps.append(step.dictionary())
	return dict


"""
Convert JSON string to Function object.
"""
func parse_json(json: String):
	var parser = JSON.parse(json)
	
	if parser.error == OK:
		var data = parser.result
#		for i in data.keys():
#			set(i, data[i])
		name = data.name
		steps.clear()
		for step in data.steps:
			steps.append(Step.new(step.method, step.parameter))
	else:
		push_error(parser.error_string)


"""
Convert Function object to JSON string.
"""
func to_json() -> String:
	return JSON.print(dictionary())

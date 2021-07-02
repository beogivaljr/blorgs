extends Object
class_name Function, "res://icon.png"

const DEFAULT_NAME = "New Function"
var name: String
var steps = []


func _init(name: String = DEFAULT_NAME):
	self.name = name


func append(method: String, parameter):
	var new_step = Step.new(method, parameter)
	steps.append(new_step)


func dictionary():
	var dict = {
		"name": name,
		"steps": steps,
	}
	return dict


func parse_json(json):
	var parser = JSON.parse(json)
	
	if parser.error == OK:
		var data = parser.result
		for i in data.keys():
			set(i, data[i])
	else:
		push_error(parser.error_string)


func to_json():
	return JSON.print(dictionary())

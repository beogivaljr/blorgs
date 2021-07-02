extends Object
class_name Step, "res://icon.png"


var method: String
var parameter

func _init(method: String, parameter):
	self.method = method
	self.parameter = parameter
	
func dictionary():
	return {
		"method": method,
		"parameter": parameter,
	}

extends Object
class_name Step, "res://icon.png"

"""
This class stores each single line instruction of a custom
Function created by Player during in Sandbox mode.
"""

"""
Key name to pre-defined base function eg. Move, Jump, Hold etc.
"""
var method: int

"""
There might be parameters of type: Real, Vector3, Quat, Transform etc.
"""
var parameter: Parameter


"""
Both properties (method and parameter) are set
when object is initialized.
"""
func _init(method: int, parameter) -> void:
	self.method = method
	if parameter is Parameter:
		self.parameter = parameter
	else:
		self.parameter = Parameter.new(parameter)


"""
Useful for JSON conversions.
"""
func dictionary() -> Dictionary:
	return {
		"method": method,
		"parameter": parameter.serialize(),
	}

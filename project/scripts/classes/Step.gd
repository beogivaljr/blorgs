extends Object
class_name Step, "res://icon.png"

"""
This class stores each single line instruction of a custom
Function created by Player during in Sandbox mode.
"""

"""
Key name to pre-defined base function eg. Move, Jump, Hold etc.
"""
var method: String

"""
This array stores every Step parameter as a real number.
There might be parameters of type: Real, Vector3, Quat, Transform etc.
"""
var parameter: PoolRealArray


"""
Both properties (method and parameter) are set
when object is initialized.
"""
func _init(method: String, parameter: PoolRealArray) -> void:
	self.method = method
	self.parameter = parameter


"""
Useful for JSON conversions.
"""
func dictionary() -> Dictionary:
	return {
		"method": method,
		"parameter": parameter,
	}

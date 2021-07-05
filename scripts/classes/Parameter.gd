extends Object
class_name Parameter, "res://icon.png"

var value


func _init(param):
	if param is PoolRealArray or param is Array:
		deserialize(param)
	elif typeof(param) == TYPE_INT:
		value = float(param)
	else:
		value = param


""" - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - SERIALIZE - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - """

"""
Every parameter should be serialized to PoolRealArray
before saving to JSON.
"""
func serialize() -> PoolRealArray:
	match typeof(value):
		TYPE_REAL:
			return [value] as PoolRealArray

		TYPE_QUAT:
			return _serialize_quat(value)

		TYPE_VECTOR3:
			return _serialize_vector(value)
				
		TYPE_TRANSFORM:
			return _serialize_transform(value)

		TYPE_OBJECT:
			if value is Spatial:
				var transform = value.global_transform
				return _serialize_transform(transform)
			else:
				push_error("An object parameter must inherit from Spatial.")
				return PoolRealArray()

		_:
			push_error("Unexpected parameter type: %s" % typeof(value))
			return PoolRealArray()


static func _serialize_vector(v: Vector3) -> PoolRealArray:
	return [v.x, v.y, v.z] as PoolRealArray

static func _serialize_quat(q: Quat) -> PoolRealArray:
	return [q.x, q.y, q.z, q.w] as PoolRealArray

static func _serialize_transform(t: Transform) -> PoolRealArray:
	return _serialize_vector(t.basis.x) + \
		_serialize_vector(t.basis.y) + \
		_serialize_vector(t.basis.z) + \
		_serialize_vector(t.origin)


""" - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - DESERIALIZE - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - """

"""
Converts from serialized parameter to a Godot engine
base type such as Transform, Vector3, Quad etc.
"""
func deserialize(array):
	if typeof(array) == TYPE_ARRAY:
		match array.size():
			1:
				value = array[0]
			3:
				value = _deserialize_vector(array)
			4:
				value = _deserialize_quat(array)
			12:
				value = _deserialize_transform(array)
			_:
				push_error("Unexpected array parameter size.")
	else:
		push_error("Unexpected parameter type.")


static func _deserialize_vector(a: PoolRealArray):
	return Vector3(a[0], a[1], a[2])

static func _deserialize_quat(a: PoolRealArray):
	return Quat(a[0], a[1], a[2], a[3])
	
static func _deserialize_transform(a: Array):
	var x_axis = _deserialize_vector(a.slice(0, 2))
	var y_axis = _deserialize_vector(a.slice(3, 5))
	var z_axis = _deserialize_vector(a.slice(6, 8))
	var origin = _deserialize_vector(a.slice(9, 11))
	return Transform(x_axis, y_axis, z_axis, origin)

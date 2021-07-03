extends Node


""" - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - MOVE - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - """

# TODO improve parameters typing based on project Wiki.
func move(instance, param):
	var target = instance.transform

	match typeof(param):
		TYPE_REAL:
			# TODO Slide body forward by "param" meters.
			pass
			
		TYPE_QUAT:
			# TODO Rotate body
			pass
			
		TYPE_VECTOR3:
			if param.is_normalized():
				# TODO Slide one meter in "param" direction
				pass
			else:
				# TODO Slide to target position.
				pass
				
		TYPE_TRANSFORM:
			# Slide to target transform.
			target = param
			
		TYPE_OBJECT:
			if param is Spatial:
				# Slide to target transform.
				target = param.global_transform
			else:
				print("An object parameter must inherit from Spatial.")
				
		_:
			push_error("Unexpected parameter type.")
		
	instance.target_transform = target


""" - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - JUMP - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - """
func jump(instance, param):
	pass


""" - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - SERIALIZE - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - """

"""
Every parameter should be serialized to PoolRealArray
before initializing a Step object.
"""
func serialize(param) -> PoolRealArray:
	match typeof(param):
		TYPE_REAL:
			return [param] as PoolRealArray

		TYPE_QUAT:
			return _serialize_quat(param)

		TYPE_VECTOR3:
			return _serialize_vector(param)
				
		TYPE_TRANSFORM:
			return _serialize_transform(param)

		TYPE_OBJECT:
			if param is Spatial:
				var transform = param.global_transform
				return _serialize_transform(transform)
			else:
				push_error("An object parameter must inherit from Spatial.")
				return PoolRealArray()
		
		_:
			push_error("Unexpected parameter type.")
			return PoolRealArray()


func _serialize_vector(v: Vector3) -> PoolRealArray:
	return [v.x, v.y, v.z] as PoolRealArray

func _serialize_quat(q: Quat) -> PoolRealArray:
	return [q.x, q.y, q.z, q.w] as PoolRealArray

func _serialize_transform(t: Transform) -> PoolRealArray:
	return _serialize_vector(t.basis.x) + \
		_serialize_vector(t.basis.y) + \
		_serialize_vector(t.basis.z) + \
		_serialize_vector(t.origin)


""" - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - DESERIALIZE - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - """

"""
Converts a parameter from Step object to Godot engine
base type such as Transform, Vector3, Quad etc.
"""
func deserialize(param):
	if typeof(param) == TYPE_ARRAY:
		match param.size():
			1:
				return param[0]
			3:
				return _deserialize_vector(param)
			4:
				return _deserialize_quat(param)
			12:
				return _deserialize_transform(param)
			_:
				push_error("Unexpected array parameter size.")
	else:
		push_error("Unexpected parameter type.")


func _deserialize_vector(a: PoolRealArray):
	return Vector3(a[0], a[1], a[2])

func _deserialize_quat(a: PoolRealArray):
	return Quat(a[0], a[1], a[2], a[3])
	
func _deserialize_transform(a: Array):
	var x_axis = _deserialize_vector(a.slice(0, 2))
	var y_axis = _deserialize_vector(a.slice(3, 5))
	var z_axis = _deserialize_vector(a.slice(6, 8))
	var origin = _deserialize_vector(a.slice(9, 11))
	return Transform(x_axis, y_axis, z_axis, origin)

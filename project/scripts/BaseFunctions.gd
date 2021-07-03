extends Object
class_name BaseFunctions, "res://icon.png"

const MOVE_SNAP = 5 # in meters.

""" - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - MOVE - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - """
static func move(instance: Spatial, param):
	var target_transform: Transform = instance.global_transform

	match typeof(param):
		TYPE_REAL:
			# Slide body forward by "param" meters.
			var forward = -target_transform.basis.z
			target_transform.origin += forward * param
			
		TYPE_BASIS:
			# Rotate body.
			target_transform.basis = param
			
		TYPE_QUAT:
			# Rotate body.
			target_transform.basis = Basis(param)
			
		TYPE_VECTOR3:
			if param.is_normalized():
				# Slide MOVE_SNAP meters in "param" direction
				target_transform.origin += MOVE_SNAP * param
			else:
				# Slide to target_transform position.
				target_transform.origin = param
			
			# And then rotate to orientate body through path.
			var rotated = instance.global_transform.looking_at(target_transform.origin, Vector3.UP)
			target_transform.basis = rotated.basis
				
		TYPE_TRANSFORM:
			# Slide to target_transform transform.
			target_transform = param
			
		TYPE_OBJECT:
			if param is Spatial:
				# Slide to target_transform transform.
				target_transform = param.global_transform
			else:
				print("An object parameter must inherit from Spatial.")
				
		_:
			push_error("Unexpected parameter type.")
		
	return target_transform


""" - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - JUMP - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - """
static func jump(instance, param):
	pass

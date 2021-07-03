extends Object
class_name BaseFunctions, "res://icon.png"

const MOVE_SNAP = 5 # in meters.
const DEFAULT_JUMP_SPEED = 15 # in meters per second

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
	var jump_speed := Vector3()
	
	match typeof(param):
		TYPE_REAL:
			# Jump up.
			jump_speed = param * instance.get_floor_normal()
			
		TYPE_VECTOR3:
			if param.is_normalized():
				# Jump toward specified direction.
				jump_speed = param * DEFAULT_JUMP_SPEED
			else:
				# TODO: Jump directly to target point.
				# HOWTO: consider gravity in a oblique trajectory.
				# EASIEST SOLUTION: Tweening.
				jump_speed = param - instance.transform.origin 
				
		TYPE_TRANSFORM:
			# Jump directly to target_transform position.
			pass
			
		TYPE_OBJECT:
			if param is Spatial:
				# Jump directly to target_transform position.
				pass
			else:
				print("An object parameter must inherit from Spatial.")
				
		_:
			push_error("Unexpected parameter type.")
		
	return jump_speed

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

	instance.target_transform = target


""" - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - JUMP - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - """
func jump(instance, param):
	pass

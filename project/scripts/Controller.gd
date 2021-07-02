extends Spatial

"""
This script controls every Minion in main scene.

	NOTE: during early development stage we're working
	with only one minion (controlled body) instance.
"""

""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - EXPORTED VARIABLES - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """

"""
Reference to Minion (controlled body prefab) scene.
"""
export(PackedScene) var minion_scene


""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - AUXILIAR VARIABLES - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """

"""
Reference to active Minion (controlled body) instance.
"""
var minion_instance = null


""" - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - REGISTER EVENTS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - """

"""
Register an input object which Controller script is going to listen for.
"""
func register(object):
	var body: PhysicsBody	
	for child in object.get_children():
		if child is PhysicsBody:
			body = child
			break
	
	if object.is_in_group("ClickableFloor"):
		_register_input_event(body, "_on_Floor_input_event")
		
	if object.is_in_group("ClickableObject"):
		_register_input_event(body, "_on_Object_input_event", [object])


"""
Unregister an input object which Controller script was listening.
"""
func unregister(object):
	if object.is_in_group("ClickableFloor"):
		_unregister_input_event(object, "_on_Floor_input_event")
		
	if object.is_in_group("ClickableObject"):
		_unregister_input_event(object, "_on_Object_input_event")


"""
Shortcut for registering input events.
"""
func _register_input_event(object: Object, method: String,  binds: Array = []):
	var result = object.connect("input_event", self, method, binds)
	if result != OK:
		print(result)


"""
Shortcut for unregistering input events.
"""
func _unregister_input_event(object: Object, method: String):
	if object.is_connected("input_event", self, method):
		object.disconnect("input_event", self, method)
	else:
		print("Controller isn't connected to any input_event of %s." %[object.name])


""" - - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - EVENTS CALLBACKS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - - """

"""
When player clicks over a ClickableFloor, we move Minion
to target position by passing click position (Vector3). 
"""
func _on_Floor_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			move(click_position)


"""
When player clicks over a ClickableObject, we move Minion to target
transform by passing reference to clicked object (Spatial).
"""
func _on_Object_input_event(_camera, event, click_position, click_normal, _shape_idx, object):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			move(click_position + click_normal)
			# TODO move(object.get_aabb().end)


""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - BASE FUNCTION: MOVE - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """

# TODO improve parameters typing based on project Wiki.
func move(param):
	# Make sure target Minion is instantiated.
	_assert_instance()
	
	match typeof(param):
		TYPE_REAL:
			# TODO Move body forward by "param" meters.
			_move_to(param)
		
		TYPE_QUAT:
			# TODO rotate
			pass
		
		TYPE_VECTOR3:
			if param.is_normalized():
				# Slide one meter in "param" direction
				_move_by(param)
			else:
				# Move to target position.
				_move_to(param)
			
		TYPE_OBJECT:
			match param.get_class():
				'Spatial':
					# move to target position and orientation
					_move_to(param.translation)
					# Quat(param.global_transform.basis)


"""
Move Minion (controlled body) to target position.
"""
func _move_to(position: Vector3):
	minion_instance.target_position = position


"""
Move Minion (controlled body) by delta position.
"""
func _move_by(deltaPosition: Vector3):
	minion_instance.target_position += deltaPosition


""" - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - HELPERS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - """

"""
Make sure Minion (controlled body) was instantiated.
"""
func _assert_instance():
	if not minion_instance:
		minion_instance = minion_scene.instance()
		call_deferred("add_child", minion_instance)

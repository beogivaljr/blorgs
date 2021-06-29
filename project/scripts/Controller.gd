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
	if object.is_in_group("ClickableFloor"):
		_register_input_event(object, "_on_Floor_input_event")
		
	if object.is_in_group("ClickableObject"):
		_register_input_event(object, "_on_Object_input_event", [object])


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
	_assert_instance()
	
	match typeof(param):
		TYPE_REAL:
			_move(param)
		
		TYPE_VECTOR3:
			_move(param)
			
		TYPE_OBJECT:
			match param.get_class():
				'Spatial':
					_move(param.translation)


"""
Move Minion (controlled body) to target position.
"""
func _move(position: Vector3):
	minion_instance.target_position = position


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

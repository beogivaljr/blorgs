extends Spatial

"""
This script controls and integrates many objects in order to
make entire core game loop (of Sandbox mode) work.
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


""" SINGLETONS """
onready var base_functions = get_node("/root/BaseFunctions")


""" CUSTOM OBJECTS """
onready var bucket := Bucket.new()


""" - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - REGISTER EVENTS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - """

func _ready():
	var objects = get_tree().get_nodes_in_group("ClickableObject")
	var floors = get_tree().get_nodes_in_group("ClickableFloor")

	for obj in objects:
		register(obj)
		
	for obj in floors:
		register(obj)
		
	_assert_instance()
	base_functions.move(minion_instance, owner.get_node("Player"))
	
	bucket.load_from_file()
	bucket.new_function('Test')
	bucket.functions[1].name = 'Test 1'
	print(bucket)


"""
Register an input object which GameManager script is going to listen for.
"""
func register(object):	
	if object.is_in_group("ClickableFloor"):
		_register_input_event(object, "_on_Floor_input_event")
		
	if object.is_in_group("ClickableObject"):
		_register_input_event(object, "_on_Object_input_event", [object])


"""
Unregister an input object which GameManager script was listening.
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
		print("GameManager isn't connected to any input_event of %s." %[object.name])


""" - - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - EVENTS CALLBACKS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - - """

"""
When player clicks over a ClickableFloor, we move Minion
to target position by passing click position (Vector3). 
"""
func _on_Floor_input_event(_camera, event, click_position, click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var basis = Basis(click_normal, 0)
			var origin = click_position
			base_functions.move(minion_instance, Transform(basis, origin))


"""
When player clicks over a ClickableObject, we move Minion to target
transform by passing reference to clicked object (Spatial).
"""
func _on_Object_input_event(_camera, event, _click_position, _click_normal, _shape_idx, object):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			base_functions.move(minion_instance, object)


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

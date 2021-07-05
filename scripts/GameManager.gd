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


""" CUSTOM OBJECTS """
onready var bucket := Bucket.new()


""" - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - REGISTER EVENTS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - """

func _ready():
#	_register_group("ClickableObject")
#	_register_group("ClickableFloor")
	
	_assert_instance()
	
	__TEST_bucket() # TODO remove this line.
#	__TEST_jump() # TODO remove this line.
#	__TEST_move_absolute() # TODO remove this line.
#	__TEST_move_forward() # TODO remove this line.
	#__TEST_move_relative() # TODO remove this line.
#	__TEST_move_rotate() # TODO remove this line.


func __TEST_bucket():
	# Load saved file (data persistence).
	bucket.load_file()
	
	# Print bucket content.
	print(bucket)
	
	# Delete all player data. (DANGER)
	bucket.delete_file()
	
	# Create a new function with an specific name.
	var fn := bucket.new_function("Example")
	
	# Set base function key name.
	var method = Method.MOVE
		
	# Append new step to function.
	fn.append(Step.new(method, global_transform))
	
	# Print bucket content.
	print(bucket)
	
	# Save file (data persistence).
	bucket.save_file()

func __TEST_jump():
	var steps = [
		Step.new(Method.MOVE, Vector3(10, 0, 10)),
		Step.new(Method.JUMP, 10),
#		Step.new("Jump", Vector3(0, 1, -1).normalized()),
#		Step.new("Jump", Vector3(0, 4, 15)),
	]
	
	var fn = Function.new("△ ( Real )", steps)
	minion_instance.attach_function(fn)

func __TEST_move_absolute():
	var method = Method.MOVE
	var steps = [
		Step.new(method, Vector3(10, 0, 10)),
		Step.new(method, Vector3(10, 0, -10)),
		Step.new(method, Vector3(-10, 0, -10)),
		Step.new(method, Vector3(-10, 0, 10)),
	]
	
	var fn = Function.new("□ ( Vector3 )", steps)
	minion_instance.attach_function(fn)

func __TEST_move_relative():
	var method = Method.MOVE
	var steps = [
		Step.new(method, Vector3(0, 0, 0)),
		Step.new(method, Vector3.FORWARD),
		Step.new(method, Vector3.RIGHT),
		Step.new(method, Vector3.BACK),
		Step.new(method, Vector3.LEFT),
	]
	
	var fn = Function.new("□ ( Unit Vector3 )", steps)
	minion_instance.attach_function(fn)

func __TEST_move_forward():
	var method = Method.MOVE
	var steps = [
		Step.new(method, Transform(Basis.IDENTITY, Vector3(10, 0, 10))),
		Step.new(method, -10),
		Step.new(method, 10),
	]
	
	var fn = Function.new("□ ( Real )", steps)
	minion_instance.attach_function(fn)

func __TEST_move_rotate():
	var method = Method.MOVE
	var steps = [
		Step.new(method, Vector3(10, 0, 10)),
		Step.new(method, Basis(Vector3.UP, PI)),
		Step.new(method, Basis(Vector3.UP, -PI)),
	]
	
	var fn = Function.new("□ ( Quat/Basis )", steps)
	minion_instance.attach_function(fn)


func _register_group(group: String):
	var objects = get_tree().get_nodes_in_group(group)
	for object in objects:
		register(object)


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
			BaseFunctions.move(minion_instance, Transform(basis, origin))


"""
When player clicks over a ClickableObject, we move Minion to target
transform by passing reference to clicked object (Spatial).
"""
func _on_Object_input_event(_camera, event, _click_position, _click_normal, _shape_idx, object):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			BaseFunctions.move(minion_instance, object)


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

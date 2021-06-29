extends MeshInstance

"""
This script registers a "Clickable" instance to Controller.
"""

"""
Get reference to Controller script.
"""
onready var controller = get_parent().get_node("Controller")


"""
Register this "Clickable" instance to Controller callbacks.
"""
func _ready():
	controller.register(self)


"""
Returns mesh bounds in 3D local space.
"""
func get_aabb():
	if mesh is PrimitiveMesh:
		return (mesh as PrimitiveMesh).get_aabb()
	elif mesh is ArrayMesh:
		return (mesh as ArrayMesh).get_aabb()

extends Area



func _ready():
	var material = $MeshInstance.get_surface_material(0)
	material.albedo_color = Color("4ed4f2")
	$MeshInstance.set_surface_material(0, material)

extends Navigation

export (float) var SPEED = 10.0
export (bool) var SHOW_PATH = true

var material = SpatialMaterial.new()

var path = []

onready var player: KinematicBody = owner.get_node("Player")
onready var camera: Camera = owner.get_node("InterpolatedCamera")
onready var camera_position: Position3D = player.get_node("CameraPosition")
onready var initial_camrot = camera_position.rotation


func _ready():
	set_process_input(true)
	material.flags_unshaded = true
	material.flags_use_point_size = true
	material.albedo_color = Color.yellow	


func _physics_process(delta):
	var direction = Vector3()

	# We need to scale the movement speed by how much delta has passed,
	# otherwise the motion won't be smooth.
	var step_size = delta * SPEED

	if path.size() > 0:
		# Direction is the difference between where we are now
		# and where we want to go.
		var destination = path[0]
		direction = destination - player.translation

		# If the next node is closer than we intend to 'step', then
		# take a smaller step. Otherwise we would go past it and
		# potentially go through a wall or over a cliff edge!
		if step_size > direction.length():
			step_size = direction.length()
			# We should also remove this node since we're about to reach it.
			path.remove(0)

		# Move the player towards the path node, by how far we want to travel.
		# Note: For a KinematicBody, we would instead use move_and_slide
		# so collisions work properly.
		player.translation += direction.normalized() * step_size
		
		if player is KinematicBody:
			print('KINEMATIC BODY')

		# Lastly let's make sure we're looking in the direction we're traveling.
		# Clamp y to 0 so the player only looks left and right, not up/down.
		direction.y = 0
		
		if direction:
			# Direction is relative, so apply it to the player's location to
			# get a point we can actually look at.
			var look_at_point = player.translation + direction.normalized()
			
			# Make the player look at the point.
			player.look_at(look_at_point, Vector3.UP)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		var target_point = get_closest_point_to_segment(from, to)

		# Set the path between the robots current location and our target.
		path = get_simple_path(player.translation, target_point, true)

		if SHOW_PATH:
			draw_path(path)

	if event is InputEventMouseMotion \
	and event.button_mask & (BUTTON_MASK_MIDDLE + BUTTON_MASK_RIGHT):
		var camrot = camera_position.rotation
		camrot.y -= event.relative.x * 0.005
		camrot.x -= event.relative.y * 0.005
		camera_position.set_rotation(camrot)
	else:
		camera_position.set_rotation(initial_camrot)


func draw_path(path_array):
	var immediateGeometry = get_node("Draw")
	immediateGeometry.set_material_override(material)
	immediateGeometry.clear()
	immediateGeometry.begin(Mesh.PRIMITIVE_POINTS, null)
	immediateGeometry.add_vertex(path_array[0])
	immediateGeometry.add_vertex(path_array[path_array.size() - 1])
	immediateGeometry.end()
	immediateGeometry.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path:
		immediateGeometry.add_vertex(x)
	immediateGeometry.end()

extends Node

signal started_movement
signal succeded_movement
signal failed_movement
signal reached_target(target)

export var speed = 7.0
export var jump_strength = 20.0
export var gravity = 98.0

onready var _body: KinematicBody = get_parent()
var _navigation: Navigation = null
var _path = []
var _target_node = null

var _velocity = Vector3.ZERO
var _snap_vector = Vector3.DOWN
var _current_physics_frames_without_moving = 0
const _MAX_PHYSICS_FRAMES_WITHOUT_MOVING = 8


func setup(navigation: Navigation):
	_navigation = navigation


func _physics_process(delta):
	if not _navigation:
		return
	## Navigation input
	var move_direction = Vector3.ZERO
	if not _path.empty():
		var next_location = _path[0] as Vector3
		var distance_vector = next_location - _body.transform.origin
		distance_vector = Vector3(distance_vector.x, 0, distance_vector.z)
		if distance_vector.length_squared() > 0.1:
			move_direction = distance_vector
		else:
			var final_distance = _body.global_transform.origin.distance_squared_to(_path[0])
			_path.remove(0)
			if _path.empty():
				if _target_node: 
					if final_distance < 1:
						emit_signal("reached_target", _target_node)
					else:
						emit_signal("failed_movement")
				else:
					emit_signal("succeded_movement")
		# Cancel if not moving after _MAX_PHYSICS_FRAMES_WITHOUT_MOVING
		if _velocity.length_squared() > 0.5:
			_current_physics_frames_without_moving = 0
		elif _current_physics_frames_without_moving <= _MAX_PHYSICS_FRAMES_WITHOUT_MOVING:
			_current_physics_frames_without_moving += 1
		else:
			_set_new_path([], null)
	
	## Movement with gravity
	move_direction = move_direction.normalized()
	_velocity.x = move_direction.x * speed * (delta * 60.0) # Phys frame rate
	_velocity.z = move_direction.z * speed * (delta * 60.0) # Phys frame rate
	_velocity.y -=  gravity * delta
	
	## Jump logic
#		var just_landed = _body.is_on_floor() and _snap_vector == Vector3.ZERO
#		var is_jumping = _body.is_on_floor() and Input.is_action_just_pressed("jump")
#		if is_jumping:
#			_velocity.y = jump_strength
#			_snap_vector = Vector3.ZERO
#		elif just_landed:
#			_snap_vector = Vector3.DOWN
	_velocity = _body.move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
		
	## Look at movement direction
	if _velocity.normalized().length() > 0.05:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_body.rotation.y = look_direction.angle()


func move_to(location: Vector3):
	var new_path = _navigation.get_simple_path(_body.transform.origin, location, true)
	_set_new_path(new_path, null)


func move_to_gate(gate: Gate):
	var starting_position = _body.transform.origin
	var _path_a = _navigation.get_simple_path(starting_position, gate.lever_target_a_position)
	var _path_b = _navigation.get_simple_path(starting_position, gate.lever_target_b_position)
	var distance_a = _get_path_length_squared(_path_a)
	var distance_b = _get_path_length_squared(_path_b)
	var new_path = _path_a if distance_a < distance_b else _path_b
	_set_new_path(new_path, gate)


func move_to_elevator(elevator: Elevator):
	_target_node = elevator
	var starting_position = _body.transform.origin
	var lower_path = _navigation.get_simple_path(starting_position, elevator.lower_position)
	var upper_path = _navigation.get_simple_path(starting_position, elevator.upper_position)
	if _get_path_length_squared(lower_path) < _get_path_length_squared(upper_path):
		_set_new_path(lower_path, elevator)
	else:
		_set_new_path(upper_path, elevator)


func move_to_button(button: MagicButton):
	button.set_lock(false)
	var starting_position = _body.transform.origin
	var path = _navigation.get_simple_path(starting_position, button.global_transform.origin)
	_set_new_path(path, button)
	yield(self, "failed_movement")
	button.set_lock(true)


func _set_new_path(path, target_node):
	_current_physics_frames_without_moving = 0
	if path.empty():
		call_deferred("emit_signal", "failed_movement")
		print("Failed movement!")
	else:
		emit_signal("started_movement")
	_target_node = target_node
	_path = path


func _get_path_length_squared(path: PoolVector3Array) -> float:
	if path.empty():
		return INF
	var path_length_squared = 0.0
	var previous_location = path[0] as Vector3
	for i in range(1, path.size()):
		var location = path[i] as Vector3
		path_length_squared += (location - previous_location).length_squared()
		previous_location = location
	return path_length_squared


func _exit_tree():
	if not _path.empty():
		emit_signal("failed_movement")

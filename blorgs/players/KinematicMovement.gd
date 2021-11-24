extends Node

signal succeded_movement
# warning-ignore:unused_signal
signal failed_movement
signal reached_target(target)

export var speed = 7.0
export var jump_strength = 20.0
export var gravity = 98.0

var _body: KinematicBody = null
var _navigation: Navigation = null
var _path = []
var _target_node = null
var _elevator_transport_up = true

var _velocity = Vector3.ZERO
var _snap_vector = Vector3.ZERO
var _current_physics_frames_without_moving = 0
const _MAX_PHYSICS_FRAMES_WITHOUT_MOVING = 4
var _previous_distance_vector = Vector3.ZERO


func setup(body: KinematicBody, navigation: Navigation):
	_body = body
	_navigation = navigation


func _physics_process(delta):
	var move_direction = Vector3.ZERO
	
	## Navigation input
	if not _path.empty():
		var next_location = _path[0] as Vector3
		var distance_vector = next_location - _body.transform.origin
		distance_vector = Vector3(distance_vector.x, 0, distance_vector.z)
		if distance_vector.length_squared() > 0.01:
			move_direction = distance_vector
		else:
			_path.remove(0)
			if _path.empty():
				if _target_node:
					emit_signal("reached_target", _target_node)
				else:
					emit_signal("succeded_movement")
		
		## Cancel if not moving after _MAX_PHYSICS_FRAMES_WITHOUT_MOVING
		if not distance_vector.is_equal_approx(_previous_distance_vector):
			_previous_distance_vector = distance_vector
		elif _current_physics_frames_without_moving <= _MAX_PHYSICS_FRAMES_WITHOUT_MOVING:
			_current_physics_frames_without_moving += 1
		else:
			_set_new_path([], null)
	
	## Movement with gravity
	move_direction = move_direction.normalized()
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -=  gravity * delta
	
	## Jump logic
#	var just_landed = _body.is_on_floor() and _snap_vector == Vector3.ZERO
#	var is_jumping = _body.is_on_floor() and Input.is_action_just_pressed("jump")
#	if is_jumping:
#		_velocity.y = jump_strength
#		_snap_vector = Vector3.ZERO
#	elif just_landed:
#		_snap_vector = Vector3.DOWN
	_velocity = _body.move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	## Look at movement direction
	if _velocity.normalized().length() > 0.1:
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
		_elevator_transport_up = true
	else:
		_set_new_path(upper_path, elevator)
		_elevator_transport_up = false


func _set_new_path(path, target_node):
	if path.empty():
		call_deferred("emit_signal", "failed_movement")
		print("Failed movement!")
	_target_node = target_node
	_path = path
	_current_physics_frames_without_moving = 0


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

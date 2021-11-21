extends Node

signal on_finished_move_to
signal on_failed_movement
signal on_reached_gate
signal on_reached_platform

export var speed = 7.0
export var jump_strength = 20.0
export var gravity = 98.0

var _body: KinematicBody = null
var _navigation: Navigation = null
var _path = []
var _target_node = null

var _velocity = Vector3.ZERO
var _snap_vector = Vector3.ZERO
var _current_physics_frames_without_moving = 0
const _MAX_PHYSICS_FRAMES_WITHOUT_MOVING = 8
var _previous_distance_vector = Vector3.ZERO

func setup(body: KinematicBody, navigation: Navigation):
	_body = body
	_navigation = navigation

func _physics_process(delta):
	var move_direction = Vector3.ZERO
	
	## DEBUG: Direct input
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	
	## Navigation input
	if not _path.empty():
		var next_location = _path[0] as Vector3
		var distance_vector = next_location - _body.transform.origin
		distance_vector = Vector3(distance_vector.x, 0, distance_vector.z)
		if distance_vector.length() > 0.1:
			move_direction = distance_vector
		else:
			_path.remove(0)
			if _path.empty():
				if _target_node is Gate:
					emit_signal("on_reached_gate")
				elif _target_node is Platform:
					emit_signal("on_reached_platform")
				else:
					emit_signal("on_finished_move_to")
				_target_node = null
		
		## Cancel if not moving after _MAX_PHYSICS_FRAMES_WITHOUT_MOVING
		if not distance_vector.is_equal_approx(_previous_distance_vector):
			_previous_distance_vector = distance_vector
		elif _current_physics_frames_without_moving <= _MAX_PHYSICS_FRAMES_WITHOUT_MOVING:
			_current_physics_frames_without_moving += 1
		else:
			_path = []
			_target_node = null
			emit_signal("on_failed_movement")
#			print("Movement cancelled!")
	
	move_direction = move_direction.normalized()
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -=  gravity * delta
	
	var just_landed = _body.is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping = _body.is_on_floor() and Input.is_action_just_pressed("jump")
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	_velocity = _body.move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.normalized().length() > 0.1:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_body.rotation.y = look_direction.angle()

func move_to(location: Vector3):
	_target_node = null
	_path = _navigation.get_simple_path(_body.transform.origin, location, true)
	if _path.empty():
		print("No path found")
	else:
#		print(_path[-1])
		pass


func move_to_gate(gate: Gate):
	_target_node = gate
	var starting_position = _body.transform.origin
	var _path_a = _navigation.get_simple_path(starting_position, gate.lever_target_a_position)
	var _path_b = _navigation.get_simple_path(starting_position, gate.lever_target_b_position)
	if _path_a.size() < _path_b.size():
		_path = _path_a
	else:
		_path = _path_b


func move_to_platform(platform: Platform):
	_target_node = platform
	var starting_position = _body.transform.origin
	_path = _navigation.get_simple_path(starting_position, platform.global_transform.origin)

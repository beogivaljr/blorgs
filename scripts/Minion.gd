extends KinematicBody

"""
External parameters, they don't change during runtime.
Should be set directly in Godot Engine.
"""
export(float) var MAX_SPEED = 10 # max speed in m/s.
export(float) var ACCEL = 12 # constant acceleration in m/s².
export(float) var DEACCEL = 2 # constant decceleration in m/s².
export(float) var DISTANCE_THRESHOLD = 0.1 # snap distance when moving  body to target position. Prevent undesired vibrations and unnecessary computations.
export(float) var ROTATION_SPEED = 360 # constant rotation speed in deg/s.

# TODO create component which freezes rotation axes, similar to Unity's Rigidbody flags.
export(bool) var ORIENTATE = true # whether to rotate to follow path orientation or not.

""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - AUXILIAR VARIABLES - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - - - - - """

"""
Runtime variables to control KinematicBody movement.
"""
var velocity := Vector3() setget private_setter
var target_transform := Transform.IDENTITY setget private_setter
var attached_function : Function setget attach_function
var moving: bool = false setget private_setter, private_getter
var current_step: int = 0 setget private_setter, private_getter

"""
Runtime parameter calculated from external one.
"""
onready var ROTATION_SPEED_RAD = deg2rad(ROTATION_SPEED)

"""
Reference to child object.
"""
onready var anim_player: = $AnimationPlayer

"""
Retrieve default gravity (m/s²) from project settings.
"""
onready var gravity = \
	ProjectSettings.get_setting("physics/3d/default_gravity") \
	* ProjectSettings.get_setting("physics/3d/default_gravity_vector")


"""
Attaching a Function also start movement.
"""
func attach_function(function: Function):
	attached_function = function
	_set_current_step(0)


"""
Move throughout function steps.
"""
func move_next():
	var next = (current_step + 1) % attached_function.length()
	_set_current_step(next)

func move_previous():
	var previous = current_step - 1
	if previous < 0: previous += attached_function.length()
	_set_current_step(previous)

func move_first():
	_set_current_step(0)
	
func move_last():
	_set_current_step(attached_function.length() - 1)

func _set_current_step(step_index: int):
	current_step = step_index
	var step = attached_function.steps[current_step]
	
	match step.method:
		Method.MOVE:
			target_transform = BaseFunctions.move(self, step.parameter.value)
			moving = true
			print("MOVING TO %s" % target_transform.origin)
			
		Method.JUMP:
			if is_on_floor():
				velocity = BaseFunctions.jump(self, step.parameter.value)
				print("JUMPING BY %s" % velocity)
				

"""
Default message from Node.
Called during the physics processing step of the main loop.
"""
func _physics_process(delta):
	_process_movement(delta)


"""
Controls KinematicBody movement according to setted target position.
"""
func _process_movement(delta):
	# Vector pointing from current to target position.
	var direction: Vector3 = target_transform.origin - translation
	var distance = direction.length()
	direction = direction.normalized()
	
	# Stop moving if both target position and rotation were achieved.
	if distance < DISTANCE_THRESHOLD:
		# TODO this check-up only considers position.
		# It should also work for jump and rotation transitions...
		moving = false
		velocity = Vector3.ZERO
		move_next()
	
	# Only applies acceleration to body if it's currently moving.
	if moving:
		# Get target velocity vector from direction.
		var target_velocity = direction * MAX_SPEED

		# Decides whether to accelerate or deccelerate according to
		# direction and current velocity (compare their direction).
		var accel
		if direction.dot(velocity) > 0:
			accel = ACCEL
		else:
			accel = DEACCEL

		# Finally apply acceleration.
		velocity = velocity.linear_interpolate(target_velocity, accel * delta)
			
	# Always apply gravity to KinematicBody.
	velocity += gravity * delta
	
	# Finally move KinematicBody.
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if ORIENTATE:
		# Update rotation by smoothly looking at target position.
		var new_transform = global_transform.looking_at(target_transform.origin, Vector3.UP)
		global_transform  = global_transform.interpolate_with(new_transform, ROTATION_SPEED_RAD * delta)
	
	
	# Update animation.
	if velocity.length() > 0:
		anim_player.play("Running")
	else:
		anim_player.play("Idle")

""" - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - HELPERS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - """

"""
Force property getter to be private.
"""
func private_getter():
	push_error("This property only allow private GET.")
	print_stack()
	pass

"""
Force property setter to be private.
"""
func private_setter(_x):
	push_error("This property only allow private SET.")
	print_stack()
	pass

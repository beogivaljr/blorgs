extends KinematicBody

"""
External parameters, they don't change during runtime.
Should be set directly in Godot Engine.
"""
export(float) var MAX_SPEED = 5	# max speed in m/s.
export(float) var ACCEL = 12 # constant acceleration in m/s².
export(float) var DEACCEL = 2 # constant decceleration in m/s².
export(float) var DISTANCE_THRESHOLD = 0.1 # snap distance when moving  body to target position. Prevent undesired vibrations and unnecessary computations.

"""
Runtime variables to control KinematicBody movement.
"""
var velocity := Vector3()
var target_position := Vector3() setget set_target_position
var moving : bool = false


"""
Setting target position also start movement when first called.
"""
func set_target_position(position):
	if target_position == Vector3.ZERO:
		translation = position
	target_position = position
	moving = true


"""
Retrieve default gravity (m/s²) from project settings.
"""
onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


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
	var direction = target_position - translation
	var distance = direction.length()
	direction = direction.normalized()
	
	# Stop moving if target position was achieved.
	if distance < DISTANCE_THRESHOLD:
		moving = false
		velocity = Vector3.ZERO		
	
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
	velocity.y -= gravity * delta
	
	# Finally move KinematicBody.
	velocity = move_and_slide(velocity, Vector3.UP)
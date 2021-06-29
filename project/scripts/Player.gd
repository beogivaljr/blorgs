extends KinematicBody

export var walk_speed = 10
export var jump_speed = 18

const MAX_SPEED = 20
const ACCEL = 4.5
const DEACCEL= 16

var velocity = Vector3()
var direction = Vector3()

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	_process_input(delta)
	_process_movement(delta)


func _process_input(_delta):
	# reset direction
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	
	direction = direction.normalized()


func _process_movement(delta):
	direction.y = 0
	direction = direction.normalized()

	velocity.y -= delta * gravity

	var target_velocity = velocity
	target_velocity.y = 0

	var target = direction
	target *= MAX_SPEED

	var accel
	if direction.dot(target_velocity) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	target_velocity = target_velocity.linear_interpolate(target, accel * delta)
	velocity.x = target_velocity.x
	velocity.z = target_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP)

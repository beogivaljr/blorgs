extends KinematicBody

export var walk_speed = 10
export var jump_speed = 18

const GRAVITY = -24.8
const MAX_SPEED = 20
const ACCEL = 4.5
const DEACCEL= 16
const MAX_SLOPE_ANGLE = deg2rad(40)


var velocity = Vector3()
var direction = Vector3()


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
		if Input.is_action_pressed("jump"):
			velocity.y = jump_speed
	
	direction = direction.normalized()


func _process_movement(delta):
	direction.y = 0
	direction = direction.normalized()

	velocity.y += delta * GRAVITY

	var hvel = velocity
	hvel.y = 0

	var target = direction
	target *= MAX_SPEED

	var accel
	if direction.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	velocity = move_and_slide(velocity, Vector3.UP, 0.05, 4, MAX_SLOPE_ANGLE)

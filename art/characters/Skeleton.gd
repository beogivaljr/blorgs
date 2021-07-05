extends KinematicBody

signal on_character_moving
signal on_character_jumping
signal on_character_done_moving
signal on_character_done_jumping

const DEFAULT_MASS = 5.0
const DEFAULT_MAX_SPEED = 10.0

var move_spell_selected = false
var jump_spell_selected = false
var move_spell_in_progress = false
var jump_spell_in_progress = false

var _velocity = Vector3.ZERO
var target_move_global_position = Vector3.ZERO

var ray_start = Vector3.ZERO
var ray_end = Vector3.ZERO

onready var camera = get_viewport().get_camera()


func _physics_process(delta):
	
	if not (target_move_global_position == Vector3.ZERO):
		_velocity = follow(
			_velocity,
			global_transform.origin,
			target_move_global_position
		)
		
		_velocity.y -= 100.0 * delta
		if is_on_floor() and jump_spell_in_progress:
			jump_spell_in_progress = false
			_velocity.y += 40.0
	
	
		_velocity = move_and_slide(_velocity, Vector3.UP)
		
		
	if (global_transform.origin - target_move_global_position).length_squared() < 0.1 \
	or _velocity.length_squared() < 1:
		stop_moving()
	
func _unhandled_input(event):
	if event.is_action_pressed("click") and \
	(move_spell_selected or jump_spell_selected):
		
		var space_state = get_world().direct_space_state
		
		var mouse_position = get_viewport().get_mouse_position()
		
		ray_start = camera.project_ray_origin(mouse_position)
		
		ray_end = ray_start + camera.project_ray_normal(mouse_position) * 2000
		
		var intersection = space_state.intersect_ray(ray_start, ray_end)
		
		if not intersection.empty() and intersection.position.y < 0.1 and intersection.position.y > -0.1:
			move_spell_in_progress = true
			target_move_global_position = intersection.position
			
			if jump_spell_selected:
				var direc = (target_move_global_position - global_transform.origin).normalized()
				target_move_global_position = global_transform.origin + direc * 3
				jump_spell_in_progress = true
			
			look_at(target_move_global_position, Vector3.UP)
			$AnimationPlayer.play("Skeleton_Running")
			move_spell_selected = false
			jump_spell_selected = false
			emit_signal("on_character_moving")
		else:
			stop_moving()

func stop_moving():
	if move_spell_in_progress or jump_spell_in_progress:
		move_spell_in_progress = false
		jump_spell_in_progress = false
		emit_signal("on_character_done_moving")
	
	target_move_global_position = Vector3.ZERO
	_velocity = Vector3.ZERO
	$AnimationPlayer.play("Skeleton_Idle")

func follow(
	velocity: Vector3,
	global_position: Vector3,
	target_position: Vector3,
	max_speed = DEFAULT_MAX_SPEED,
	mass = DEFAULT_MASS
) -> Vector3:
	var desired_velocity = (target_position - global_position).normalized() * max_speed
	var stearing = (desired_velocity - velocity) / mass
	return velocity + stearing

func jump():
	jump_spell_selected = true
	pass

func hold():
	pass

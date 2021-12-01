extends Spatial

const _PAN_SPEED = 0.025

export var max_vertical_pan_offset = 8.0
export var max_horizontal_pan_offset = 14.0

var target_to_follow: Node
var _block_target_follow = false


func _process(delta):
	if target_to_follow and not _block_target_follow:
		transform.origin = lerp(transform.origin, target_to_follow.transform.origin, delta)
	
	var relative_x = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	var relative_z = Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
	if relative_x or relative_z:
		pan_camera_keyboard(relative_x, relative_z)


func pan_camera(event):
	var pan_offset = Vector3(-event.relative.x, 0, -event.relative.y) * _PAN_SPEED
	if (
		abs(pan_offset.x + global_transform.origin.x) <= max_horizontal_pan_offset
		and abs(pan_offset.z + global_transform.origin.z) <= max_vertical_pan_offset
		):
			translate(pan_offset)


func pan_camera_keyboard(relative_x, relative_y):
	var pan_offset = Vector3(relative_x, 0, relative_y) * _PAN_SPEED * 4
	if (
		abs(pan_offset.x + global_transform.origin.x) <= max_horizontal_pan_offset
		and abs(pan_offset.z + global_transform.origin.z) <= max_vertical_pan_offset
		):
			translate(pan_offset)


func on_touch_began(event):
	_block_target_follow = true


func on_touch_ended(event):
	_block_target_follow = false

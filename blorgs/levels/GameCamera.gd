extends Spatial

export var max_vertical_pan_offset = 8.0
export var max_horizontal_pan_offset = 14.0

const _PAN_SPEED = 0.025

func pan_camera(event):
	if event is InputEventScreenDrag:
		var pan_offset = Vector3(-event.relative.x, 0, -event.relative.y) * _PAN_SPEED
		if (
			abs(pan_offset.x + global_transform.origin.x) <= max_horizontal_pan_offset
			and abs(pan_offset.z + global_transform.origin.z) <= max_vertical_pan_offset
			):
				translate(pan_offset)
	else:
		print("WRONG INPUT CALL")

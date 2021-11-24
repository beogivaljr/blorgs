class_name Elevator
extends StaticBody

signal on_interaction_done

var lower_position = Vector3.ZERO
var upper_position = Vector3.ZERO


func _ready():
	lower_position = $LowerPortal.global_transform.origin
	upper_position = $UpperPortal.global_transform.origin


func transport(body: KinematicBody, up: bool):
	if up:
		body.global_transform.origin = $UpperPortal.global_transform.origin + Vector3(0, 1, 0)
	else:
		body.global_transform.origin = $LowerPortal.global_transform.origin + Vector3(0, 1, 0)
	emit_signal("on_interaction_done")

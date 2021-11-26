class_name Elevator
extends StaticBody

signal spell_done(succeded, interactable)

var lower_position = Vector3.ZERO
var upper_position = Vector3.ZERO


func _ready():
	lower_position = $LowerPortal.global_transform.origin
	upper_position = $UpperPortal.global_transform.origin


func transport(body: KinematicBody):
	var body_location = body.global_transform.origin
	var distance_sq_to_lower = (body_location - lower_position).length_squared()
	var distance_sq_to_upper = (body_location - upper_position).length_squared()
	var closer_to_lower = distance_sq_to_lower < distance_sq_to_upper
	if closer_to_lower:
		body.global_transform.origin = upper_position + Vector3(0, 1, 0)
	else:
		body.global_transform.origin = lower_position + Vector3(0, 1, 0)
	emit_signal("spell_done", true, self)

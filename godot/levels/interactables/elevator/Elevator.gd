class_name Elevator
extends StaticBody

signal transported_up(elevator_name)
signal transported_down(elevator_name)

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
		emit_signal("transported_up", self.name)
	else:
		body.global_transform.origin = lower_position + Vector3(0, 1, 0)
		emit_signal("transported_down", self.name)


func on_spell_selected(spell_id):
	if spell_id == GlobalConstants.SpellIds.USE_ELEVATOR:
		_set_touch_highlight_visible(true)
	else:
		_set_touch_highlight_visible(false)


func on_spell_started(_spell_id):
	on_spell_selected(null)


func _set_touch_highlight_visible(is_visible):
	$HighlightMeshInstance.visible = is_visible
	$HighlightMeshInstance2.visible = is_visible

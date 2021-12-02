class_name Gate
extends StaticBody

signal gate_lowered(node_name)
signal gate_raised(node_name)

var lever_target_a_position = Vector3.ZERO
var lever_target_b_position = Vector3.ZERO

var _is_raised = true
onready var animation_player = $AnimationPlayer
const _LEVER_ANIMATION_NAME = "LowerLever"


func _ready():
	animation_player.connect("animation_finished", self, "_move_gate")
	lever_target_a_position = $LeverTarget.global_transform.origin
	lever_target_b_position = $LeverTarget2.global_transform.origin


func toggle_raise_lower():
	_is_raised = not _is_raised
	if _is_raised:
		animation_player.play_backwards("LowerLever")
	else:
		animation_player.play("LowerLever")


func on_spell_selected(spell_id):
	if spell_id == GlobalConstants.SpellIds.TOGGLE_GATE:
		_set_touch_highlight_visible(true)
	else:
		_set_touch_highlight_visible(false)


func on_spell_started(_spell_id):
	on_spell_selected(null)


func _set_touch_highlight_visible(is_visible):
	$HighlightMeshInstance.visible = is_visible


func _on_interaction_done_raised():
	if _is_raised:
		emit_signal("gate_raised", self.name)


func _on_interaction_done_lowered():
	if not _is_raised:
		emit_signal("gate_lowered", self.name)


func _move_gate(finished_animation):
	if finished_animation == _LEVER_ANIMATION_NAME:
		if _is_raised:
			animation_player.play_backwards("Lower")
		else:
			animation_player.play("Lower")

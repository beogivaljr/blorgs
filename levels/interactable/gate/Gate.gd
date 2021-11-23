class_name Gate
extends KinematicBody

signal on_interaction_done

var lever_target_a_position = Vector3.ZERO
var lever_target_b_position = Vector3.ZERO

var _is_raised = true
onready var animation_player = $AnimationPlayer
const _LEVER_ANIMATION_NAME = "LowerLever"


func _ready():
	animation_player.connect("animation_finished", self, "_move_gate")
	lever_target_a_position = $LeverTarget.global_transform.origin
	lever_target_b_position = $LeverTarget2.global_transform.origin


func _on_interaction_done_raised():
	if _is_raised:
		emit_signal("on_interaction_done")

func _on_interaction_done_lowered():
	if not _is_raised:
		emit_signal("on_interaction_done")


func toggle_raise_lower():
	_is_raised = not _is_raised
	if _is_raised:
		animation_player.play_backwards("LowerLever")
	else:
		animation_player.play("LowerLever")


func _move_gate(finished_animation):
	if finished_animation == _LEVER_ANIMATION_NAME:
		if _is_raised:
			animation_player.play_backwards("Lower")
		else:
			animation_player.play("Lower")

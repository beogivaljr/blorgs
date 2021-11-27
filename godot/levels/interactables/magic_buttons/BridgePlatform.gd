extends Spatial

signal platform_activated(node_name)
signal platform_deactivated(node_name)

onready var is_active = false setget _set_is_active, _get_is_active
onready var _animation_player = $AnimationPlayer
const _ANIMATION_NAME = "Activate"


func activate(button_name):
	_animation_player.play(_ANIMATION_NAME)


func deactivate(button_name):
	_animation_player.play_backwards(_ANIMATION_NAME)


func _get_is_active():
	return is_active


func _set_is_active(value):
	push_error("Cannot set this variable directly, use activate() instead.")


func _on_AnimationPlayer_animation_finished(anim_name):
	if _get_is_active():
		emit_signal("platform_deactivated", self.name)
	else:
		emit_signal("platform_activated", self.name)

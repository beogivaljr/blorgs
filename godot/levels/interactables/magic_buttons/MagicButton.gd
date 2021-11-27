class_name MagicButton
extends StaticBody

signal button_activated(node_name)
signal button_deactivated(node_name)

export(GlobalConstants.SpellIds) var unlock_spell_id = GlobalConstants.SpellIds.PRESS_SQUARE_BUTTON

const _BUTTON_ANIMATION_NAME = "PressDown"
const _PLATFORM_ANIMATION_NAME = "MovePlatformForward"
const _LOCKED_SCALE = Vector3(1, 2, 1)
const _UNLOCKED_SCALE = Vector3(1, 1, 1)

var is_pressed = false
onready var _animation_player = $AnimationPlayer
onready var _collision_shape = $CollisionShape
onready var is_locked = _collision_shape.scale == _LOCKED_SCALE setget _set_is_locked, _get_is_locked


func _ready():
	set_lock(true)


func press():
	_animation_player.play(_BUTTON_ANIMATION_NAME)


func release():
	_animation_player.play_backwards(_BUTTON_ANIMATION_NAME)


func set_lock(lock: bool):
	if lock:
		_collision_shape.scale = _LOCKED_SCALE
	else:
		_collision_shape.scale = _UNLOCKED_SCALE


func _set_is_locked(value):
	push_error("Cannot set this variable directly, use set_lock(bool) instead.")


func _get_is_locked():
	return is_locked


func _on_AnimationPlayer_animation_finished(animation_name):
	match animation_name:
		_BUTTON_ANIMATION_NAME:
			is_pressed = not is_pressed
			if is_pressed:
				_animation_player.play(_PLATFORM_ANIMATION_NAME)
			else:
				_animation_player.play_backwards(_PLATFORM_ANIMATION_NAME)
		_PLATFORM_ANIMATION_NAME:
			if is_pressed:
				emit_signal("button_activated", self.name)
			else:
				set_lock(true)
				emit_signal("button_deactivated", self.name)
		_:
			var error = "Node: " + name + " unhandled animation name"
			push_error(error)

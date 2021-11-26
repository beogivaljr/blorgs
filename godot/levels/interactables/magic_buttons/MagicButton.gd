class_name MagicButton
extends StaticBody

signal spell_done(succeded, interactable)

export(GlobalConstants.SpellIds) var unlock_spell_id = GlobalConstants.SpellIds.PRESS_SQUARE_BUTTON

const _BUTTON_ANIMATION_NAME = "PressDown"

var is_pressed = false
var _bodies_pressing = {}


func attempt_to_press(spell_id, body_id):
	_bodies_pressing[body_id] = spell_id
	if spell_id == unlock_spell_id:
		if not is_pressed:
			$AnimationPlayer.play(_BUTTON_ANIMATION_NAME)
		else:
			emit_signal("spell_done", true, self)


func attempt_to_release(body_id):
	_bodies_pressing.erase(body_id)
	if _bodies_pressing.size() == 0 and is_pressed:
		$AnimationPlayer.play_backwards(_BUTTON_ANIMATION_NAME)


func _on_AnimationPlayer_animation_finished(_anim_name):
	if _bodies_pressing.size() > 0:
		is_pressed = true
		emit_signal("spell_done", true, self)
	else:
		is_pressed = false

class_name BasePlayer
extends KinematicBody

signal spell_started(spell_id)
signal spell_done(succeded, interactable, spell_id)

const _SPELLS = GlobalConstants.SpellIds

onready var kinematic_movement = $KinematicMovement
onready var collision_detector = $Area
var _active_spell = null setget set_active_spell_id


func setup(navigation: Navigation, interactables):
	kinematic_movement.setup(self, navigation)
	for interactable in interactables:
		interactable.connect("spell_done", self, "_on_spell_done")


func set_active_spell_id(spell_id):
	_active_spell = spell_id


func cast_spell(node, location):
	match _active_spell:
		null:
			return
		_SPELLS.MOVE_TO:
			if location is Vector3:
				kinematic_movement.move_to(location)
				emit_signal("spell_started", _active_spell)
		_SPELLS.TOGGLE_GATE:
			if node is Gate:
				kinematic_movement.move_to_gate(node)
				emit_signal("spell_started", _active_spell)
		_SPELLS.USE_ELEVATOR:
			if node is Elevator:
				kinematic_movement.move_to_elevator(node)
				emit_signal("spell_started", _active_spell)
		_SPELLS.PRESS_SQUARE_BUTTON, _SPELLS.PRESS_ROUND_BUTTON:
			if node is MagicButton:
				if node.unlock_spell_id == _active_spell:
					emit_signal("spell_started", _active_spell)
					if collision_detector.overlaps_body(node):
						_on_Area_body_entered(node)
					kinematic_movement.move_to_button(node)


func _on_spell_done(succeded, interactable):
	emit_signal("spell_done", succeded, interactable, _active_spell)
	set_active_spell_id(null)


func _on_KinematicMovement_reached_target(target):
	assert(target)
	if target is Gate and _active_spell == _SPELLS.TOGGLE_GATE:
		target.toggle_raise_lower()
	elif target is Elevator and _active_spell == _SPELLS.USE_ELEVATOR:
		target.transport(self)


func _on_KinematicMovement_succeded_movement():
	if _active_spell == _SPELLS.MOVE_TO:
		_on_spell_done(true, null)


func _on_KinematicMovement_failed_movement():
	_on_spell_done(false, null)


func _on_Area_body_entered(body):
	if body is MagicButton:
		body.attempt_to_press(_active_spell, self.name)


func _on_Area_body_exited(body):
	if body is MagicButton:
		body.attempt_to_release(self.name)

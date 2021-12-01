class_name BaseCharacter
extends KinematicBody

signal spell_started(spell_id)
signal spell_done(succeded)

const _SPELLS = GlobalConstants.SpellIds

var character_type = null
var _active_spell_id = null setget begin_casting_spell
onready var _kinematic_movement = $KinematicMovement


func setup(navigation: Navigation, type):
	assert(type != null)
	self.character_type = type
	$KinematicMovement.setup(navigation)


func begin_casting_spell(spell_id):
	_active_spell_id = spell_id


func _attempt_to_cast_spell_on_target(node, location):
	var spell = _active_spell_id
	if (
		spell == _SPELLS.MOVE_TO
		and location is Vector3
	):
		_cast_move_to_spell(location)
	elif (
		spell == _SPELLS.TOGGLE_GATE
		and node is Gate
	):
		_cast_toggle_gate_spell(node)
	elif (
		spell == _SPELLS.USE_ELEVATOR
		and node is Elevator
	):
		_cast_use_elevator_spell(node)
	elif (
		(spell == _SPELLS.PRESS_SQUARE_BUTTON or spell == _SPELLS.PRESS_ROUND_BUTTON) 
		and node is MagicButton
		and node.unlock_spell_id == _active_spell_id and not node.is_pressed
		):
		_cast_press_button_spell(node)
	else:
		# Not a valid target
		return
	emit_signal("spell_started", _active_spell_id)


func _cast_move_to_spell(location: Vector3):
	_kinematic_movement.move_to(location)


func _cast_toggle_gate_spell(gate: Gate):
	_kinematic_movement.move_to_gate(gate)


func _cast_use_elevator_spell(elevator: Elevator):
	_kinematic_movement.move_to_elevator(elevator)


func _cast_press_button_spell(button: MagicButton):
	_kinematic_movement.move_to_button(button)


func _on_spell_done(succeded, interactable):
	emit_signal("spell_done", succeded)
	begin_casting_spell(null)


func _on_KinematicMovement_reached_target(target):
	assert(target)
	if target is Gate and _active_spell_id == _SPELLS.TOGGLE_GATE:
		target.toggle_raise_lower()
	elif target is Elevator and _active_spell_id == _SPELLS.USE_ELEVATOR:
		target.transport(self)
	elif target is MagicButton:
		target.press()
		yield(_kinematic_movement, "started_movement")
		target.release()


func _on_KinematicMovement_succeded_movement():
	if _active_spell_id == _SPELLS.MOVE_TO:
		_on_spell_done(true, null)


func _on_KinematicMovement_failed_movement():
	_on_spell_done(false, null)

extends KinematicBody

signal spell_started(spell_id)
signal spell_done(succeded, interactable, spell_id)

const _SPELLS = GlobalConstants.SpellIds

onready var kinematic_movement = $KinematicMovement
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

class_name BaseCharacter
extends KinematicBody

signal spell_started(spell_id)
signal spell_done(succeded)
signal invalid_spell_target_selected

const _SPELLS = GlobalConstants.SpellIds

var character_type = null
var _navigation_grid: GridMap
var _active_spell_id = null setget begin_casting_spell
onready var _kinematic_movement = $KinematicMovement


func setup(navigation: Navigation, type):
	assert(type != null)
	self.character_type = type
	_navigation_grid = navigation.get_child(0)
	$KinematicMovement.setup(navigation)


func begin_casting_spell(spell_id):
	_active_spell_id = spell_id


func force_fail_current_spell():
	emit_signal("spell_started", _active_spell_id)
	call_deferred("_on_spell_done", false, null)


func _attempt_to_cast_spell_on_target(node, location):
	var spell = _active_spell_id
	if (
		spell == _SPELLS.MOVE_TO
		and location is Vector3
	):
		if node is Gate:
			location = node.transform.origin
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
		_toggle_navigation(true, node)
		call_deferred("_cast_press_button_spell", node)
	elif (
		spell == _SPELLS.SUMMON_ASCENDING_PORTAL
		or spell == _SPELLS.SUMMON_DESCENDING_PORTAL
		or spell == _SPELLS.DESTROY_SUMMON
	):
		pass
	else:
		# Not a valid target
		emit_signal("invalid_spell_target_selected")
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


func _on_spell_done(succeded, _interactable):
	emit_signal("spell_done", succeded)
	begin_casting_spell(null)


func _toggle_navigation(activate, interactable):
	for tile_world_position in interactable.navigtion_pivot.get_children():
		var grid_position_vector = _navigation_grid.world_to_map(tile_world_position.global_transform.origin)
		var x = grid_position_vector.x
		var y = grid_position_vector.y
		var z = grid_position_vector.z
		var item = 0 if activate else GridMap.INVALID_CELL_ITEM
		_navigation_grid.set_cell_item(x, y, z, item)


func _on_KinematicMovement_reached_target(target):
	assert(target)
	if target is Gate and _active_spell_id == _SPELLS.TOGGLE_GATE:
		target.toggle_raise_lower()
	elif target is Elevator and _active_spell_id == _SPELLS.USE_ELEVATOR:
		target.transport(self)
	elif target is MagicButton:
		target.press()
		yield(_kinematic_movement, "started_movement")
		_toggle_navigation(false, target)
		target.release()


func _on_KinematicMovement_succeded_movement():
	if _active_spell_id == _SPELLS.MOVE_TO:
		_on_spell_done(true, null)


func _on_KinematicMovement_failed_movement():
	_on_spell_done(false, null)

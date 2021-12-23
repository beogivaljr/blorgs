class_name BaseWorld
extends Spatial

signal spell_started(spell_id)
signal spell_done(succeded)
signal spell_selected(spell_id)

const _SPELLS = GlobalConstants.SpellIds
var players_on_finish_line = 0
var _active_spell_id = null
var _active_player_id = null
var _players: Dictionary
var _current_character_for_player_id: Dictionary
var _disassembled_creatures_for_player_id: Dictionary
onready var _world_input_handler = $WorldInputHandler


func _ready():
	_world_input_handler.connect("dragged", $GameCamera, "pan_camera")
	_world_input_handler.connect("touch_began", $GameCamera, "on_touch_began")
	_world_input_handler.connect("touch_ended", $GameCamera, "on_touch_ended")
	_world_input_handler.connect("clicked", self, "_handle_world_click")
	_bind_interactables()


func _on_spell_started(spell_id):
	$Navigation.visible = false
	emit_signal("spell_started", spell_id)


func _bind_interactables():
	for child in get_children():
		if child is Gate:
			child.setup($Navigation/NavGrid)
			connect("spell_selected", child, "on_spell_selected")
			connect("spell_started", child, "on_spell_started")
			child.connect("gate_lowered", self, "_on_gate_lowered")
			child.connect("gate_raised", self, "_on_gate_raised")
		elif child is Elevator:
			connect("spell_selected", child, "on_spell_selected")
			connect("spell_started", child, "on_spell_started")
			child.connect("transported_up", self, "_on_transported_up")
			child.connect("transported_down", self, "_on_transported_down")
		elif child is MagicButton:
			connect("spell_selected", child, "on_spell_selected")
			connect("spell_started", child, "on_spell_started")
			for bridge_platform in get_tree().get_nodes_in_group(child.name):
				connect("spell_selected", bridge_platform, "on_spell_selected")
				connect("spell_started", bridge_platform, "on_spell_started")
				child.target_locations.append(bridge_platform.global_transform.origin)
				child.connect("button_activated", bridge_platform, "activate")
				child.connect("button_deactivated", bridge_platform, "deactivate")
				bridge_platform.connect("platform_activated", self, "_on_brigde_platform_activated")
				bridge_platform.connect("platform_deactivated", self, "_on_brigde_platform_deactivated")
		elif child is FinishLine:
			child.connect("player_entered_finish_line", self, "_on_player_entered_finish_line")
			child.connect("player_exited_finish_line", self, "_on_player_exited_finish_line")
		elif child is CreatureSpawner:
			connect("spell_selected", child, "on_spell_selected")
			connect("spell_started", child, "on_spell_started")


# Gate
func _on_gate_lowered(gate_name):
	_toggle_navigation(true, gate_name)
	emit_signal("spell_done", true)


func _on_gate_raised(gate_name):
	_toggle_navigation(false, gate_name)
	emit_signal("spell_done", true)


#Elevator
func _on_transported_up(elevator_name):
	emit_signal("spell_done", true)


func _on_transported_down(elevator_name):
	emit_signal("spell_done", true)


# MagicButtons
func _on_brigde_platform_activated(brigde_platform_name):
	emit_signal("spell_done", true)


func _on_brigde_platform_deactivated(brigde_platform_name):
	pass


# FinishLine
func _on_player_entered_finish_line():
	players_on_finish_line += 1


func _on_player_exited_finish_line():
	players_on_finish_line -= 1


func _toggle_navigation(activate, interactable_name):
	var interactable = get_node(interactable_name)
	var navigation = $Navigation/NavGrid
	for tile_world_position in interactable.navigtion_pivot.get_children():
		var grid_position_vector = navigation.world_to_map(tile_world_position.global_transform.origin)
		var x = grid_position_vector.x
		var y = grid_position_vector.y
		var z = grid_position_vector.z
		var item = 0 if activate else GridMap.INVALID_CELL_ITEM
		navigation.set_cell_item(x, y, z, item)


func begin_casting_spell(spell_id):
	_active_spell_id = spell_id
	emit_signal("spell_selected", spell_id)
	$Navigation.visible = spell_id == GlobalConstants.SpellIds.MOVE_TO
	if _is_valid_destroy_summon(spell_id):
		emit_signal("spell_started", spell_id)
		if get_active_character() is Creature:
			_disassemble_creature()
			call_deferred("emit_signal", "spell_done", true)
		else:
			call_deferred("emit_signal", "spell_done", false)


func _attempt_to_cast_spell_on_target(node, location):
	var spell = _active_spell_id
	if _is_valid_summon_creature(spell, node):
		emit_signal("spell_started", _active_spell_id)
		_cast_summon_spell(node)
	else:
		# Not a valid target
		return


# Creature spawner
func _cast_summon_spell(creature_spawner: CreatureSpawner):
	_cleanup_creatures()
	_spawn_and_setup_creature(creature_spawner)
	call_deferred("emit_signal", "spell_done", true)


func _cleanup_creatures():
	var character = get_active_character()
	if _disassembled_creatures_for_player_id.has(_active_player_id):
		var disassembled_creature = _disassembled_creatures_for_player_id[_active_player_id]
		if disassembled_creature:
			(disassembled_creature as Creature).destroy()
			_disassembled_creatures_for_player_id.erase(_active_player_id)
	elif character is Creature:
		character.destroy()


func _disassemble_creature():
	var creature = get_active_character() as Creature
	set_active_character(_players[_active_player_id])
	creature.disassemble()
	_disassembled_creatures_for_player_id[_active_player_id] = creature


func _spawn_and_setup_creature(creature_spawner: CreatureSpawner):
	var creature = preload("res://players/creatures/Creature.tscn").instance()
	creature.connect("spell_started", self, "_on_spell_started")
	creature.connect("spell_done", self, "_on_spell_done")
	creature.connect("invalid_spell_target_selected", self, "_on_invalid_spell_target_selected")
	add_child(creature, true)
	creature.spawner = creature_spawner
	creature.global_transform = creature_spawner.global_transform
	creature.setup($Navigation, GlobalConstants.CharacterTypes.NONE)
	set_active_character(creature)


func set_active_character(character: BaseCharacter):
	_current_character_for_player_id[_active_player_id] = character


func get_active_character() -> BaseCharacter:
	return _current_character_for_player_id[_active_player_id]


func _on_spell_done(succeded):
	emit_signal("spell_done", succeded)


# Validators
func _is_valid_move_to(spell, location):
	 return (
		spell == _SPELLS.MOVE_TO 
		and location is Vector3
	)


func _is_valid_toggle_gate(spell, node):
	 return (
		spell == _SPELLS.TOGGLE_GATE
		and node is Gate
	)


func _is_valid_use_elevator(spell, node):
	 return (
		spell == _SPELLS.USE_ELEVATOR
		and node is Elevator
	)


func _is_valid_magic_button(spell, node):
	 return (
		(spell == _SPELLS.PRESS_SQUARE_BUTTON or spell == _SPELLS.PRESS_ROUND_BUTTON) 
		and node is MagicButton
		and node.unlock_spell_id == _active_spell_id and not node.is_pressed
	)


func _is_valid_summon_creature(spell, node):
	 return (
		(spell == _SPELLS.SUMMON_ASCENDING_PORTAL
		or spell == _SPELLS.SUMMON_DESCENDING_PORTAL)
		and node is CreatureSpawner
		and node.summon_spell_id == _active_spell_id
	)


func _is_valid_destroy_summon(spell_id):
	 return spell_id == _SPELLS.DESTROY_SUMMON


func _on_invalid_spell_target_selected():
	pass


func _handle_world_click(_event, _intersection):
	pass


func _on_KillYArea_body_entered(_body):
	pass

class_name BaseWorld
extends Spatial

signal spell_started(spell_id)
signal spell_done(succeded)

const _SPELLS = GlobalConstants.SpellIds
var _active_spell_id = null
var _active_player_id = null
var _players: Dictionary
var _current_character_for_player_id: Dictionary
var _disassembled_creatures_for_player_id: Dictionary
onready var _world_input_handler = $WorldInputHandler


func _ready():
	_world_input_handler.connect("on_dragged", $GameCamera, "pan_camera")


func begin_casting_spell(spell_id, player_id):
	_active_spell_id = spell_id
	_active_player_id = player_id
	if spell_id == _SPELLS.DESTROY_SUMMON:
		if get_active_character() is Creature:
			_disassemble_creature()
			emit_signal("spell_started", spell_id)
			call_deferred("emit_signal", "spell_done", true)
		else:
			emit_signal("spell_started", spell_id)
			call_deferred("emit_signal", "spell_done", false)


func attempt_to_cast_spell_on(node, location):
	var spell = _active_spell_id
	if (
		spell == _SPELLS.SUMMON_ASCENDING_PORTAL
		and node is CreatureSpawner
		and node.summon_spell_id == _active_spell_id
	):
		_cast_summon_spell(node)
	elif (
		spell == _SPELLS.SUMMON_DESCENDING_PORTAL
		and node is CreatureSpawner
		and node.summon_spell_id == _active_spell_id
	):
		_cast_summon_spell(node)
	else:
		# Not a valid target
		return
	emit_signal("spell_started", _active_spell_id)


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
	call_deferred("emit_signal", "spell_done", true)


func _spawn_and_setup_creature(creature_spawner: CreatureSpawner):
	var creature = preload("res://players/creatures/Creature.tscn").instance()
	creature.connect("spell_started", self, "_on_spell_started")
	creature.connect("spell_done", self, "_on_spell_done")
	add_child(creature, true)
	creature.spawner = creature_spawner
	creature.global_transform = creature_spawner.global_transform
	creature.setup($Navigation)
	set_active_character(creature)


func set_active_character(character: BaseCharacter):
	_current_character_for_player_id[_active_player_id] = character


func get_active_character() -> BaseCharacter:
	return _current_character_for_player_id[_active_player_id]


func _on_spell_started(spell_id):
	emit_signal("spell_started", spell_id)


func _on_spell_done(succeded):
	emit_signal("spell_done", succeded)


func _on_KillYArea_body_entered(body):
	pass
